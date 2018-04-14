#!/bin/bash

PROJECT_DIR=.
RENAME_CLASSES=./rename_classes.txt

#First, we substitute the text in all of the files.
sed_cmd=`sed -e 's@^@s/[[:<:]]@; s@[[:space:]]\{1,\}@[[:>:]]/@; s@$@/g;@' ${RENAME_CLASSES} `
echo ${sed_cmd}
find . -type f \( -name "*.pbxproj" -or -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.cpp" -or -name "*.xib" -or -name "*.storyboard" \) -exec sed -i.bak "${sed_cmd}" {} +

echo "bwfore read line:"${RENAME_CLASSES}


## Now, we rename the .h/.m files
#
echo ${RENAME_CLASSES}
while read line; do
echo "read line:"${line}
class_from=`echo $line | sed "s/[[:space:]]\{1,\}.*//"`
class_to=`echo $line | sed "s/.*[[:space:]]\{1,\}//"`
echo "class_from:":${class_from}
echo "class_to:":${class_to}
echo "read line"

#modify name
find ${PROJECT_DIR} -type f -regex ".*[[:<:]]${class_from}[[:>:]][^\/]*\.[hm]" -print | egrep -v '.bak$' | \
while read file_from; do
echo "file_from:":${file_from}
file_to=`echo $file_from | sed "s/\(.*\)[[:<:]]${class_from}[[:>:]]\([^\/]*\)/\1${class_to}\2/"`
echo "file_to:":${file_to}
echo mv "${file_from}" "${file_to}"
mv "${file_from}" "${file_to}"
done


#modify name
find ${PROJECT_DIR} -type f -regex ".*[[:<:]]${class_from}[[:>:]][^\/]*\.xib" -print | egrep -v '.bak$' | \
while read file_from; do
echo "file_from:":${file_from}
file_to=`echo $file_from | sed "s/\(.*\)[[:<:]]${class_from}[[:>:]]\([^\/]*\)/\1${class_to}\2/"`
echo "file_to:":${file_to}
echo mv "${file_from}" "${file_to}"
mv "${file_from}" "${file_to}"
done 

#modify name
find ${PROJECT_DIR} -type f -regex ".*[[:<:]]${class_from}[[:>:]][^\/]*\.mm" -print | egrep -v '.bak$' | \
while read file_from; do
echo "file_from:":${file_from}
file_to=`echo $file_from | sed "s/\(.*\)[[:<:]]${class_from}[[:>:]]\([^\/]*\)/\1${class_to}\2/"`
echo "file_to:":${file_to}
echo mv "${file_from}" "${file_to}"
mv "${file_from}" "${file_to}"
done
done < ${RENAME_CLASSES}

#
find ${PROJECT_DIR} -type f \
\( -name "*.pbxproj.bak" -or -name "*.h.bak" -or -name "*.m.bak" -or -name "*.mm.bak" -or -name "*.cpp.bak" -or -name "*.xib.bak" -or -name "*.storyboard.bak" \) \
-exec rm -f {} \;



