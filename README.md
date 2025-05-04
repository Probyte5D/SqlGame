🎲 Gioco dell'Oca
Welcome to the Gioco dell'Oca project! This digital version of the classic Italian board game uses MySQL to track player moves, game squares, and game logs. Through stored procedures and a well-designed database, the game simulates the player's journey across various squares, each with unique effects.

📸 Screenshots
Database Structure	Game Flow	Example Log

| ![Logs](Images/logs.png) | ![Game](Images/GiocoSQL.png) | 

🧾 Description
This project is an implementation of the Gioco dell'Oca (Goose Game), an interactive digital version where players roll the dice, move across squares, and encounter different game events. The game is managed via a MySQL database and stored procedures, and each player's actions are logged for review.

The key components include:

A database structure that manages players, squares, and game logs.

Stored procedures for game logic (e.g., determining moves, handling turns).

A clear game flow based on rolling dice and interacting with various types of squares: Normal, Penalty, Goose, Prize, and End.


🎯 Main Features:
Random turn assignment using stored procedures

Game squares with different actions (Normal, Penalty, Goose, Prize, End)

Dynamic player movement based on dice rolls

Game logs that track each player's actions and results

Player score tracking

🛠️ Technologies Used
Technology	Usage
MySQL	Database management, player data, game logic
SQL	Stored procedures for game operations (turns, moves, logging)
PHP	(Optional) Could be used for creating a front-end if you expand the project


🚀 Main Functionalities
🌐 Game Logic powered by SQL procedures

🎲 Dice Rolling simulation to determine player moves

🏆 Game End condition: First player to reach the final square wins

📜 Game Log to track player movements and actions

🕹️ Square Types that impact player movement (Penalty, Goose, etc.)

🛠️ Project Structure

gioco-dell-oca/
│

├── GiocoSql.sql             # DatabaseStructure+ Stored Procedures
├── README.md             # This file
└── images/               # Folder with database and gameplay images
    ├── db-structure.png

🧪 How to Play the Game
Clone the repository
If you wish to experiment with the project locally, start by cloning the repository to your computer:


git clone https://github.com/your-username/gioco-dell-oca.git
Set Up the Database
Open your MySQL client and run the SQL commands in the game.sql file to create the database and necessary tables. Make sure the stored procedures are correctly created to manage game logic.

Run the Game
Execute the gioco() stored procedure to start the game. Players will take turns rolling the dice and moving across the game board until one reaches the final square.

View the Game Log
After each turn, the actions and results are logged in the gioco_log table. Query this table to view the players' progress and the outcome of each move.

🔮 Future Developments
Frontend Interface: Implement a simple web-based interface for users to interact with the game (using HTML/CSS/JavaScript).

Player Management: Add functionality for creating accounts and saving game progress.

Multiplayer Feature: Allow multiple users to join and play the game simultaneously via a web interface.

📄 License
This project is licensed under the MIT License. You are free to use, modify, and distribute the code.

MIT License
Copyright (c) Probyte 2025

Permission is hereby granted

✨ Acknowledgments
Created with ❤️ by [Probyte]. The game logic and database structure were inspired by the traditional Gioco dell'Oca board game, made digital!

