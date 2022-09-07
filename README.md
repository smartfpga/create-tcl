A tcl script for restoring your projects from a previously exported block-design script in Vivado. 
Using this script is useful for version control, because you don't have to store the whole bulky Vivado projects.

The root directory must contain the following subdirectories:

Warning(!): this is not the project directory for Vivado!
   /src <-- for your *.hdl files
   /proj_dir <-- this will be the Vivado project directory
   /constraints <-- please save all constraints here
   /sim <-- here the simulation files (from which the "sim_1" file set is generated)

The script for creating the block design (file name: bd.tcl) must also be in the root directory

The important steps to successfully set up your project:
1. Prepare subdirectories as indicated above;
2. Change the project name (the variable "proj_name") in the create.tcl script;
3. Modify in the create.tcl the path to the root directory (root_dir);
4. Check that the block design script is named "bd.tcl". Rename if necessary;
5. Specify chip model and development board if present;
6. In your block-design script (bd.tcl), which you exported from Vivado, comment out the assignment of the variable str_bd_folder.
7. Go to the prepared root directory in the Vivado console and type "source create.tcl".
8. Enjoy!
