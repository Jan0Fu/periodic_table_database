  if [[  $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
  else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    
    FIND_PROPERTY_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    echo $FIND_PROPERTY_RESULT | while IFS='|' read NUMBER MASS MELT_PT BOIL_PT TYPE_ID
    do
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_PT celsius and a boiling point of $BOIL_PT celsius."
    done
  fi
fi