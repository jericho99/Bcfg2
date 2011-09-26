#!/usr/bin/env python

'''Build debian/ubuntu package indexes'''
__revision__ = '$Id: create-debian-pkglist.py 15905 2009-01-07 14:29:51Z sgraber $'

# Original code from Bcfg2 sources

import glob, gzip, lxml.etree, os, re, urllib, cStringIO, sys, ConfigParser, apt_pkg
apt_pkg.init()


def debug(msg):
    '''print debug messages'''
    if '-v' in sys.argv:
        sys.stdout.write(msg)

def get_as_list(somestring):
    """ Input : a string like this : 'a, g, f,w'
        Output : a list like this : ['a', 'g', 'f', 'w'] """
    return somestring.replace(' ', '').split(',')

def list_contains_all_the_same_values(l):
    if len(l) == 0:
        return True
    # The list contains all the same values if all elements in 
    # the list are equal to the first element.
    first = l[0]
    for elem in l:
        if first != elem:
            return False
    return True

class SourceURL:
    def __init__(self, deb_url, arch):
        deb_url_tokens = deb_url.split()
        # ex: deb http://somemirror.com/ubuntu dapper main restricted universe
        self.url = deb_url_tokens[1]
        self.distribution = deb_url_tokens[2]
        self.sections = deb_url_tokens[3:]
        self.arch = arch
    
    def __str__(self):
        return "deb %s %s %s" % (self.url, self.distribution, ' '.join(self.sections))
    
    def __repr__(self):
        return "<%s %s>" % (self.__class__.__name__, str(self))

class Source:
    def __init__(self, confparser, section, bcfg2_repos_prefix):
        self.filename = "%s/Pkgmgr/%s.xml" % (bcfg2_repos_prefix, section)
        self.groups = get_as_list(confparser.get(section, "group_names"))
        self.priority = confparser.getint(section, "priority")
        self.architectures = get_as_list(confparser.get(section, "architectures"))
        self.arch_specialurl = set()

        self.source_urls = []
        self.source_urls.append(SourceURL(confparser.get(section, "deb_url"),"all"))
        # Agregate urls in the form of deb_url0, deb_url1, ... to deb_url9
        for i in range(10): # 0 to 9
            option_name = "deb_url%s" % i
            if confparser.has_option(section, option_name):
                self.source_urls.append(SourceURL(confparser.get(section, option_name),"all"))

        # Aggregate architecture specific urls (if present)
        for arch in self.architectures:
            if not confparser.has_option(section, "deb_"+arch+"_url"):
                continue
            self.source_urls.append(SourceURL(confparser.get(section, "deb_"+arch+"_url"),arch))
            # Agregate urls in the form of deb_url0, deb_url1, ... to deb_url9
            for i in range(10): # 0 to 9
                option_name = "deb_"+arch+"_url%s" % i
                if confparser.has_option(section, option_name):
                    self.source_urls.append(SourceURL(confparser.get(section, option_name),arch))
                    self.arch_specialurl.add(arch)
   
        self.file = None
        self.indent_level = 0

    def __str__(self):
        return """File: %s
Groups: %s
Priority: %s
Architectures: %s
Source URLS: %s""" % (self.filename, self.groups, self.priority, self.architectures, self.source_urls)
    
    def __repr__(self):
        return "<%s %s>" % (self.__class__.__name__, str(self))

    def _open_file(self):
        self.file = open(self.filename + '~', 'w')
    
    def _close_file(self):
        self.file.close()

    def _write_to_file(self, msg):
        self.file.write("%s%s\n" % (self.indent_level * '    ', msg))

    def _rename_file(self):
        os.rename(self.filename + '~', self.filename)

    def _pkg_version_is_older(self, version1, version2):
        """ Use dpkg to compare the two version
            Return true if version1 < version2 """
        # Avoid forking a new process if the two strings are equals
        if version1 == version2:
            return False
        status = apt_pkg.VersionCompare(version1, version2)
        return status < 0

    def _update_pkgdata(self, pkgdata, source_url):
        for section in source_url.sections:
            for arch in self.architectures:
                if source_url.arch != arch and source_url.arch != "all":
                    continue
                if source_url.arch == "all" and arch in self.arch_specialurl:
                    continue
                url = "%s/dists/%s/%s/binary-%s/Packages.gz" % (source_url.url, source_url.distribution, section, arch)
                debug("Processing url %s\n" % (url))
                try:
                    data = urllib.urlopen(url)
                    buf = cStringIO.StringIO(''.join(data.readlines()))
                    reader = gzip.GzipFile(fileobj=buf)
                    for line in reader.readlines():
                        if line[:8] == 'Package:':
                            pkgname = line.split(' ')[1].strip()
                        elif line[:8] == 'Version:':
                            version = line.split(' ')[1].strip()
                            if pkgdata.has_key(pkgname):
                                if pkgdata[pkgname].has_key(arch):
                                    # The package is listed twice for the same architecture
                                    # We keep the most recent version
                                    old_version = pkgdata[pkgname][arch]
                                    if self._pkg_version_is_older(old_version, version):
                                        pkgdata[pkgname][arch] = version
                                else:
                                    # The package data exists for another architecture,
                                    # but not for this one. Add it.
                                    pkgdata[pkgname][arch] = version
                            else:
                                # First entry for this package
                                pkgdata[pkgname] = {arch:version}
                        else:
                            continue
                except:
                    raise Exception("Could not process URL %s\n%s\nPlease verify the URL." % (url, sys.exc_value))
        return pkgdata
    
    def _get_sorted_pkg_keys(self, pkgdata):
            pkgs = []
            for k in pkgdata.keys():
                pkgs.append(k)
            pkgs.sort()
            return pkgs

    def _write_common_entries(self, pkgdata):
        # Write entries for packages that have the same version
        # across all architectures
        #coalesced = 0
        for pkg in self._get_sorted_pkg_keys(pkgdata):
            # Dictionary of archname: pkgversion
            # (There is exactly one version per architecture)
            archdata = pkgdata[pkg]
            # List of versions for all architectures of this package
            pkgversions = archdata.values()
            # If the versions for all architectures are the same
            if len(self.architectures) == len(pkgversions) and list_contains_all_the_same_values(pkgversions):
                # Write the package data
                ver = pkgversions[0]
                self._write_to_file('<Package name="%s" version="%s"/>' % (pkg, ver))
                #coalesced += 1
                # Remove this package entry
                del pkgdata[pkg]

    def _write_perarch_entries(self, pkgdata):
        # Write entries that are left, i.e. packages that have different 
        # versions per architecture
        #perarch = 0
        if pkgdata:
            for arch in self.architectures:
                self._write_to_file('<Group name="%s">' % (arch))
                self.indent_level = self.indent_level + 1
                for pkg in self._get_sorted_pkg_keys(pkgdata):
                    if pkgdata[pkg].has_key(arch):
                        self._write_to_file('<Package name="%s" version="%s"/>' % (pkg, pkgdata[pkg][arch]))
                        #perarch += 1
                self.indent_level = self.indent_level - 1
                self._write_to_file('</Group>')
        #debug("Got %s coalesced, %s per-arch\n" % (coalesced, perarch))

    def process(self):
        '''Build package indices for source'''
        
        # First, build the pkgdata structure without touching the file,
        # so the file does not contain incomplete informations if the
        # network in not reachable.
        pkgdata = {}
        for source_url in self.source_urls:
            pkgdata = self._update_pkgdata(pkgdata, source_url)
        
        # Construct the file.
        self._open_file()
        for source_url in self.source_urls:
            self._write_to_file('<!-- %s -->' % source_url)
        
        self._write_to_file('<PackageList priority="%s" type="deb">' % self.priority)
        
        self.indent_level = self.indent_level + 1
        for group in self.groups:
            self._write_to_file('<Group name="%s">' % group)
            self.indent_level = self.indent_level + 1
        
        self._write_common_entries(pkgdata)
        self._write_perarch_entries(pkgdata)
        
        for group in self.groups:
            self.indent_level = self.indent_level - 1
            self._write_to_file('</Group>')
        self.indent_level = self.indent_level - 1
        self._write_to_file('</PackageList>')
        self._close_file()
        self._rename_file()

if __name__ == '__main__':
    # Prefix is relative to script path
    complete_script_path = os.path.join(os.getcwd(), sys.argv[0])
    prefix = complete_script_path[:-len('etc/create-debian-pkglist.py')]
    
    confparser = ConfigParser.SafeConfigParser()
    confparser.read(prefix + "etc/debian-pkglist.conf")
    
    # We read the whole configuration file before processing each entries
    # to avoid doing work if there is a problem in the file.
    sources_list = []
    for section in confparser.sections():
        sources_list.append(Source(confparser, section, prefix))

    for source in sources_list:
        source.process()
