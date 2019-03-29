#!/bin/sh

#### ARCHIVO PARA EMPAREJAR LAS COSAS CON ESPACIOS ES MAS FACIL
##FUNCION PARA NO COPIAR Y PEGAR CODIGO, MEJOR PRACTICA!!!
empareja_espacios(){
	cat  $1 | grep -o -E "^[^ 	]*(	*)" | awk '{ print length($0); }' > spaced
	IFS=$'\r\n' GLOBIGNORE='*' command eval  'spaced=($(cat  spaced ))'
	rm -rf spaced
	len="${#spaced[@]}"
	m=0
	k=0
	while [ $m -lt $len ];
	#for (( m=0; m<$len; m++ ));
	do
		espacios_a_sumar=$(($2-${spaced[$m]}))
		while [ $k -le $espacios_a_sumar ];
		#for (( k=0; k<=$espacios_a_sumar; k++ ));
		do
			printf " " >> espacios
			k=$(($k+1))
		done
		espacios_ya_bien=$(cat espacios)
		linea=$(($m+1))
		sed -i "$(printf $linea)s/\t/$(printf "%s" "$espacios_ya_bien")/g" $1 
		rm -rf espacios
		m=$(($m+1))
		k=0
	done
	#cat  $1 | grep -o -E "^[_Aa0-Zz9]*( *)" | awk '{ print length($0); }' | sort -nr
}
rm -rf part1
rm -rf part2
rm -rf part3
rm -rf part4 
rm -rf tempfilex.phy
rm -rf tempfiley.phy
rm -rf archivo_semi
rm -rf copy_file.phy
echo "START AT: "
date
cp $1 copy_file.phy
sed -i '1d' copy_file.phy
tab=$(cat  copy_file.phy | grep -o -E "^[^ 	]*(	*)" | awk '{ print length($0); }' | sort -nr | head -1)
esp=$(cat  copy_file.phy | grep -o -E "^[^ 	]*( *)" | awk '{ print length($0); }' | sort -nr | head -1)
if [ $tab -gt $esp ]; 
then
	echo "$tab"
	empareja_espacios copy_file.phy $tab
else
	###SIMPLEMENTE LO FORZO A QUE SEA COMO EL CASO ANTERIOR
	sed -i 's/ \+/\t/g' copy_file.phy
	tab=$(cat  copy_file.phy | grep -o -E "^[^ 	]*(	*)" | awk '{ print length($0); }' | sort -nr | head -1)
	echo "$tab"
	empareja_espacios copy_file.phy $tab
fi
cat $2 | tr -d " \t\r" > part2 
sed 's/^.*=//' part2 > part1
sed 's/-.*//' part1 > part3
sed -i '1d' part3
con=$(($tab-1))
#mapfile -t part3 < <(cat part3 | sort -n)
IFS=$'\r\n' GLOBIGNORE='*' command eval  'part3=($(cat part3))'
j=0
len="${#part3[@]}"
rm -rf part4
j=0
#for (( j=0; j<$len; j++ ));
while [ $j -lt $len ];
do
	part3[$j]=$((part3[$j]+con)) 
	echo "${part3[$j]}" >> part4
	j=$(($j+1))
done
IFS=$'\r\n' GLOBIGNORE='*' command eval  'part4=($(cat part4 | sort -nr))'
len="${#part4[@]}"
a="y"
b="x"
#counter=0
#len="${#arr[@]}"
cp copy_file.phy tempfile$a.phy
j=0
while [ $j -lt $len ];
#for (( j=0; j<$len; j++ ));
do
	printf "Processing locus %s of %s\n" "$(($j+1))" "$len"
	sed "s/./&\t/${part4[$j]}"  tempfile$a.phy  > tempfile$b.phy
	if [ $j -eq $(($len-1)) ]
	then
		cat tempfile$b.phy > archivo_semi
	fi
	if [ $a = "y" ]
	then
   		a="x"
   		b="y"
	else
   		a="y"
   		b="x"
	fi
	j=$(($j+1))
done
sed 's/ \+/\t/g' archivo_semi > output.phy
rm -rf part1
rm -rf part2
rm -rf part3
rm -rf part4 
rm -rf tempfilex.phy
rm -rf tempfiley.phy
rm -rf archivo_semi
rm -rf copy_file.phy
echo "SUCCESS AT: "
date
echo "A file with loci separated by tabs has been printed to output.phy :) Please cite as: Pavón-Vázquez, E.A., & C.J. Pavón-Vázquez. 2019. SeATTLE: Sequence Alignment Transformation into a Table for Later Edition. Available at : https://github.com/CarlosPavonV/seattle"
