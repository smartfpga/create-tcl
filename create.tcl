#****************************************************************************************
# Vivado Projekt Erzeugungsscript 
# Zusammengestellt von Dmitry Eliseev auf der Basis von Greg's Script. 
# Die ursprüngliche Datei ist hier zu finden:
# http://forums.xilinx.com/t5/Design-Entry/Vivado-and-version-control/td-p/347941/page/2
# Das root-Verzeichnis muss die folgenden Unterverzeichnisse beinhalten:
# Achtung: das ist nicht das Project-Verzeichnis für VIVADO.
#   /src  <-- für eure *.hdl Dateien
#   /proj_dir <-- dieses wird als Projektsverzeichnis von Vivado wahrgenommen
#   /constraints <-- hier bitte alle constraints speichern
#	/sim <-- hier die Simulationsdateien (aus den wird der "sim_1" Dateisatz generiert)
# Das Script für die Erzeugung des Blockdesigns (Dateiname: bd.tcl) muss sich
# auch im root-Verzeichnis befinden 
#
# Die wichtigen Schritte zum erfolgreichen Aufbau Ihres Projektes:
# 1. Unterverzeichnisse wie oben angegeben vorbereiten
# 2. Projekt Name (die Variabel "proj_name") unten ändern
# 3. Pfad zum root-Verzeichnis (root_dir) modifizieren 
# 4. Prüfen, dass das Blockdesign-Skript den Namen "bd.tcl" hat.  Ggf. umbenennen.
# 5. Chip-Modell und, falls vorhanden, die Entwicklungsplatine angeben 
# 6. !!! In dem aus Vivado exportierten bd-Script die Zuweisung der 
#    Variabel str_bd_folder auskommentieren
# 7. In der Vivado-console zu dem vorbereiteten root Verzeichnis 
#    übergehen und "source create.tcl" eintippen
#
# Updates:
# Rev 1.0 		11. Dezember 2015 - Erzeugt   
# Rev 1.1		25. Februar 2016 - Simulationsdateien werden 
#                   vom Script zum Project hinzugefügt
#****************************************************************************************

set proj_name "IhrProjektName"
set root_dir {c:/Projects/RootFolderName}

set proj_dir $root_dir/proj_dir
set src_dir $root_dir/src
set ip_dir $root_dir/ip
set lib_dir $root_dir/lib
set constr_dir $root_dir/constraints
set sim_dir $root_dir/sim

# !!! Diese Variabel wird später vom Blockdesign-Script benutzt. 
# In dem aus Vivado exportierten BD-Script muss diese Variabel auskommentiert werden!!!
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

# Kopieren der Simulationsdateien. Dateisatz 'sim_1' 
set file_list [glob -nocomplain "$sim_dir/*"]
if {[llength $file_list] != 0} {
	add_files -fileset sim_1 $sim_dir
} else {
	puts "$sim_dir beinhaltet keine Dateien"
}

set file_list [glob -nocomplain "$constr_dir/*"]
if {[llength $file_list] != 0} {
	add_files -fileset constrs_1 $constr_dir
} else {
	puts "$constr_dir beinhaltet keine Dateien"
}

# Erzeugung des Block-Designs
source $root_dir/bd.tcl

# Generate the wrapper
set design_name [get_bd_designs]
make_wrapper -files [get_files $design_name.bd] -top -import

# Am Ende die Darstellung des Block-Designs schön machen
regenerate_bd_layout