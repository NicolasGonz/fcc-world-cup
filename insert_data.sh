#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")

    if [[ -z $WINNER_ID ]]
    then
      WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER') ")

      if [[ $WINNER_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
  fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")

    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT') ")
    
      if [[ $OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT    
      fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ");
  fi

fi

  if [[ YEAR != 'year' ]]
  then
    GAME_ID=$($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ($WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND') ")
    if [[ $GAME_ID == 'INSERT 0 1' ]]
    then
      echo Inserted winner team, $ROUND - $WINNER_ID
    fi
  fi

done
