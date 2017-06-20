# Helpful Bash Scripts

### Functions

#### bashreload()
  This will search your home directory for a **.bash_profile** or **.bashrc** file and then will source it.
  
#### cs()
  Takes you into a directory and displays contents. Requires one argument (the name of the directory that you will be moving into)
  
#### clearl()
  This will clear the terminal and list the contents of the current directory.
  
#### mcd()
  This will create a directory, cd into it, and then list its contents (using `ll`). Requires one argument (the name of the directory to be created). 
  *Note: Last time I was using this one I had some issues so it may not be fully functional*
  
#### up()
  This will move up one directory and list the contents of the directory.
  
#### gitp()
  This will preform a `git pull` in the current directory. If you provide it with an argument it should preform the `git pull` in that directory without taking you out of your current directory.
  
#### gitn()
  This will create a new git branch in the repository and check it out. Requires at least one argument (the name of the branch to be created).
  


