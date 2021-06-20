# #!/usr/bin/env bash

###################################################################################################
##
##  Скрипт позволяет генерировать проект с заданным именем
##
##  1. Клонирует репозиторий mylib;
##  2. Меняет mylib на указанное название;
##  3. Фиксирует изменения.
##
###################################################################################################

if [[ $# -lt 2 || $# -gt 4 ]]; then
    required="<path/to/new/project/directory> <ProjectName>"
    optional="<lowercase_project_name> <UPPERCASE_PROJECT_NAME>"
    echo "Usage: $0 $required [$optional]"
    exit
fi

#--------------------------------------------------------------------------------------------------
#
#   Работа с именем нового проекта
#
#--------------------------------------------------------------------------------------------------

project_name=$2

echo "Project name would be \"$project_name\""

if [ -n "$3" ]; then
    project_name_lowercase=$3
    echo "Lowercase project name would be \"$project_name_lowercase\""
else
    project_name_lowercase=$(echo "$project_name" | tr "[:upper:]" "[:lower:]")
    echo "Lowercase project name is not specified. \"$project_name_lowercase\" will be used"
fi

if [ -n "$4" ]; then
    project_name_uppercase=$4
    echo "Uppercase project name would be \"$project_name_uppercase\""
else
    project_name_uppercase=$(echo "$project_name" | tr "[:lower:]" "[:upper:]")
    echo "Uppercase project name is not specified. \"$project_name_uppercase\" will be used"
fi

function replace_project_name ()
{
    sed "s/Mylib/$project_name/g" |\
    sed "s/mylib/$project_name_lowercase/g" |\
    sed "s/MYLIB/$project_name_uppercase/g"\
        < /dev/stdin
}

#--------------------------------------------------------------------------------------------------
#
#   Работа с директорией нового проекта
#
#--------------------------------------------------------------------------------------------------

project_path=$1
project_dir=$project_path/$project_name

if [ -d "$project_dir" ]; then
    while true; do
        read -p "Directory $project_dir already exists. Use it? (y/N): " choice
        case $choice in
            [Yy] ) break;;
            [Nn] ) exit;;
            ""   ) exit;;
        esac
    done
fi

echo "$project_name would be placed into $project_dir"
mkdir -p $project_dir

#--------------------------------------------------------------------------------------------------
#
#   Генерация
#
#--------------------------------------------------------------------------------------------------

function transform ()
{
    local files=$@

    for file in $files; do
        new_file=$(echo $file | replace_project_name)
        echo "Transforming $project_dir/$file into $project_dir/$new_file"

        cat $project_dir/$file | replace_project_name > .${project_name}_buffer_$$
        cat .${project_name}_buffer_$$ > $project_dir/$file
        rm .${project_name}_buffer_$$

        mkdir -p $(dirname $project_dir/$new_file)
        mv $project_dir/$file $project_dir/$new_file
    done
}

git clone https://github.com/izvolov/mylib.git $project_dir

transform $(git -C $project_dir ls-files)

git -C $project_dir add .

git -C $project_dir config user.email dmitriy@izvolov.ru
git -C $project_dir config user.name "Дмитрий Изволов"

git -C $project_dir commit -m "Mylib -> $project_name"

git -C $project_dir config --unset user.email
git -C $project_dir config --unset user.name

git -C $project_dir clean -df
