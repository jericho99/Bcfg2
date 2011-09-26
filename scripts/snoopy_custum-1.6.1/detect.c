/* detect.c -- simple execve() wrapper detection 
 * $Id: detect.c 25 2010-02-11 20:58:06Z bostjanskufca $
 * Copyright (c) 2000 marius@linux.com,mbm@linux.com
 *
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#include <stdio.h>
#include <dlfcn.h>

#ifndef RTLD_DEFAULT
#  define RTLD_DEFAULT ((void *) 0)
#endif

int main(void) {
	void *handle = dlopen("/lib/libc.so.6", RTLD_LAZY);
	//simple test to see if the execve in memory matches libc.so.6
	if (dlsym(handle, "execve") != dlsym(RTLD_DEFAULT, "execve"))
		printf("something fishy...\n");
	else
		printf("secure\n");
	return 0;
}
