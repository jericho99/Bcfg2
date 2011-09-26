find . -name '* *' | while read file;
do
target=`echo "$file" | sed 's/ /SSS/g'`;
echo "Renaming '$file' to '$target'";
mv "$file" "$target";
done;

