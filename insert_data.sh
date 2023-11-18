#! /bin/bash


if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo "$($PSQL "TRUNCATE TABLE games, teams")"
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
  do
    if [[ $YEAR != "year" ]]
    then
    #get winner
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
    #not found
      if [[ -z $WIN_ID ]] 
      then
      #INSERT WIN
        INSERT_WINNER_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                                    
        if [[ $INSERT_WINNER_NAME_RESULT = "INSERT 0 1" ]]
        then
          echo "Inserted winner into teams, $WINNER"
      fi
        #get new id 
        WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")

      fi

      #get opponent
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #NOT FOUND
      if [[ -z $OPPONENT_ID ]] 
      then
      #INSERT OPP
        INSERT_OPP_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPP_NAME_RESULT = "INSERT 0 1" ]]
        then
        echo "Inserted opponent into teams, $OPPONENT"
        fi
      #get new id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
      #insert info abt games DATA=YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
      INSERT_GAME_INF=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPPONENT_ID, $WINNER_G, $OPPONENT_G)")



    fi

done
