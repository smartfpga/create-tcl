#******************************************************************************************
# Vivado Projekt Erzeugungsscript 
# Zusammengestellt von Dmitry Eliseev auf der Basis von Greg's Script. 
# Das Original ist hier zu finden:
# http://forums.xilinx.com/t5/Design-Entry/Vivado-and-version-control/td-p/347941/page/2
# Das root-Verzeichnis muss die folgenden Unterverzeichnisse beinhalten:
# Achtung: das ist nicht das Project-Verzeichnis für VIVADO.
#    /src  <-- für eure *.hdl Dateien
#    /proj_dir <-- dieses wird als Projektsverzeichnis von Vivado wahrgenommen
#    /constraints <-- hier bitte alle constraints speichern
# Das Script für die Erzeugung des Blockdesigns muss sich auch im root-Verzeichnis befinden 
#
# Eure Schritte zum Erfolg:
# 1. Verzeichnisse wie oben angegeben vorbereiten
# 2. Projekt Name (proj_name) ändern
# 3. Pfad zum root-Verzeichnis (root_dir) modifizieren. 
# 4. Chip-Modell und, falls vorhanden, die Entwicklungsplatine angeben 
# 5. In dem bd-Script die Zuweisung der Variabel str_bd_folder auskommentieren
#
# Updates:
# 11. Dezember 2015 - Erzeugt Rev 1.0 
#******************************************************************************************

set proj_name "MusterKrokodil"
set root_dir {c:/Projects/MusterKrokodilRoot}

set proj_dir $root_dir/proj_dir
set src_dir $root_dir/src
set ip_dir $root_dir/ip
set lib_dir $root_dir/lib
set constr_dir $root_dir/constraints

# !!! Diese Variabel wird später bei der Erstellung des Blockdesigns benutzt
set str_bd_folder $proj_dir/bd

# Create project
create_project $proj_name $proj_dir
puts "INFO: Project created: $proj_name"

# Set project properties
set obj [get_projects $proj_name]

# Chip Modell:
set_property "part" "xc7z020clg400-1" $obj

# Entwicklungsplatine (falls vorhanden)
set_property "board_part" "em.avnet.com:microzed_7020:part0:1.0" $obj

# Restliche Scheiße:
set_property "default_lib" "xil_defaultlib" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "VHDL" $obj

# Add sources. Vorerst aber überpfrüfen ob das Verzeichnis nicht leer ist.
set file_list [glob -nocomplain "$src_dir/*"]
if {[llength $file_list] != 0} {
	add_files $src_dir
} else {
	puts "$src_dir beinhaltet keine Dateien"
}


# foreach subdir [glob -type d $ip_dir/*] {
# import_files [glob $subdir/*.xci]
# }

set file_list [glob -nocomplain "$constr_dir/*"]
if {[llength $file_list] != 0} {
	add_files -fileset constrs_1 $constr_dir
} else {
	puts "$constr_dir beinhaltet keine Dateien"
}

# Add custom IP repository
# set obj [get_filesets sources_1]
# set_property "ip_repo_paths" $lib_dir $obj
# update_ip_catalog


# Erzeugung des Block-Designs

source $root_dir/bd.tcl

# Generate the wrapper
set design_name [get_bd_designs]
make_wrapper -files [get_files $design_name.bd] -top -import

# Am Ende die Darstellung des Block-Designs schön machen
regenerate_bd_layout