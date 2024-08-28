#!/bin/bash
if [[ -z $1 ]]; then
echo -e "Please provide an element as an argument."
exit
else
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
COLUMN=''
if [[ $1 =~ ^[A-Za-z]{1,2}$ ]]; then
COLUMN='symbol'
elif [[ $1 =~ ^[A-Za-z]{3,}$ ]]; then
COLUMN='name'
elif [[ $1 =~ ^[0-9]+$ ]]; then
COLUMN='atomic_number'
fi
if [[ $COLUMN = 'atomic_number' ]]; then
QUERY=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number LEFT JOIN types t ON p.type_id = t.type_id WHERE e.$COLUMN = $1;")
else
QUERY=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number LEFT JOIN types t ON p.type_id = t.type_id WHERE e.$COLUMN = '$1';")
fi
if [[ -z $QUERY ]]; then
echo 'I could not find that element in the database.'
else
echo $QUERY | while IFS='|' read -r ATOMIC SYMBOL NAME MASS MELTING BOILING TYPE
do
echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
fi
fi