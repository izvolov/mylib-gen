[:ru: Оригинал](README.md)

Project generator based on the Mylib template
=============================================

Generates a project with the desired name using [Mylib](https://github.com/izvolov/mylib) template project.

I can't wait
------------

```bash
bash <(curl -s https://raw.githubusercontent.com/izvolov/mylib-gen/master/create.sh) path/to/project/directory MyFavouriteLibraryName
```

Details, please
---------------

```
create.sh
    path/to/project/directory   # Directory to place a project to excluding project itself.
                                # Example: /home/myname/projects

    ProjectName                 # Required argument.
                                # Case sensitive.
                                # This is the name of the project.
                                # Would be used in names of exported cmake targets.

    [lowercase_project_name]    # Optional argument.
                                # Default: lower(ProjectName) = projectname
                                # Case sensitive.
                                # Would be used in namespaces, directory names and
                                # local cmake targets.

    [UPPERCASE_PROJECT_NAME]    # Optional argument.
                                # Default: upper(ProjectName) = PROJECTNAME
                                # Case sensitive.
                                # Would be used in cmake variables.
````
