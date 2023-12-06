Certainly, here's a very concise guide with just the essential commands for running C code in the Windows Subsystem for Linux (WSL):

1. **Install WSL**:
   - Follow Microsoft's official documentation to enable WSL and install a Linux distribution from the Microsoft Store.

2. **Open WSL**:
   - Launch WSL using the `wsl` command.

3. **Write, Compile, and Run C Code**:
   - Create your C code and save it in WSL.
   - Compile and run your C program:

     ```bash
     gcc -o my_program my_program.c
     ./my_program
     ```

   Replace `my_program` with your program's name and `my_program.c` with your C source code file.

4. **Exiting WSL**:
   - To exit WSL and return to Windows, type `exit` in the terminal.