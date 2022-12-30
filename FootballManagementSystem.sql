/* 
    ************************************************* 
                    CREATE TABLES
    *************************************************
*/

-- 1) Create Teams Players
CREATE TABLE TEAM
(
    team_id                 INT                 PRIMARY KEY,
    team_name               VARCHAR(100),
    city                    VARCHAR(100),
    president               VARCHAR(100),
    captain_id              INT,
    manager_id              INT,
    stadium_id              INT
    -- Need to add foreign key for manager, captain, and stadium
);


-- 2) Create Players and Attribute Table
CREATE TABLE PLAYER
(
    player_id               INT                 PRIMARY KEY,
    player_name             VARCHAR(100),
    player_dob              DATE,
    player_age              INT,
    playing_position        VARCHAR(100),
    player_jerseyNo         INT,
    player_nationality      VARCHAR(100),
    team_id                 INT,                                    -- Foreign key from team
    attribute_id            INT,                                    -- Foreign key from attribute
    contract_id             INT                                     -- foreign key from Contract table
);
-- Need to put View for age, drieved attribute

CREATE TABLE PLAYER_ATTRIBUTE
(
    attribute_id            INT                 PRIMARY KEY,
    player_id               INT                                     -- Foreign key from Player table
);

CREATE TABLE GK_ATTRIBUTES
(
    gk_attribute_id         INT                 PRIMARY KEY,
    attribute_id            INT,                                    -- Foreign key from Attributes table
    
    -- Rating below is out of 10 with 10 being the highest
    gk_ball_handling        INT,
    gk_reflexes             INT,
    leadership              INT,
    shooting                INT
);


CREATE TABLE PL_ATTRIBUTES
(
  pl_attribute_id           INT                 PRIMARY KEY,
  attribute_id              INT,                                    -- Foreign key from Pl attrubutes table
  
   -- Rating below is out of 10 with 10 being the highest
   speed                    INT,
   ball_control             INT,
   dribbling                INT,
   passing_accuracy         INT,
   positioning              INT
);

-- 3) Create Stadium Table
CREATE TABLE STADIUM
(
    stadium_id              INT                 PRIMARY KEY,
    stadium_name            VARCHAR(100),
    stadium_capacity        INT
);


-- 4) Create table Achievement
CREATE TABLE ACHIEVEMENT
(
    title_year              INT                 PRIMARY KEY,
    FA_winner               INT,
    PL_Winner               INT
    
    -- both the FA_winner and PL_winner is the foreign key from Teams table
);


-- 5) Create Sponsors tables
CREATE TABLE PLAYER_SPONSOR
(
    sponsor_id              INT                 PRIMARY KEY,
    player_id               INT,                                    -- Foreign key from Player table.
    sponsor_name            VARCHAR(100)
);

CREATE TABLE TEAM_SPONSOR
(
    sponsor_id              INT                 PRIMARY KEY,
    team_id                 INT,                                    -- Foreign key from Club table.
    sponsor_name            VARCHAR(100)
);


-- 6) Create Staff Table
CREATE TABLE STAFF
(
   staff_id                 INT                 PRIMARY KEY,
   staff_member_name        VARCHAR(100),
   staff_type               VARCHAR(100),                           -- e.g medical or coach
   team_id                  INT,
   contract_id              INT                                     -- foreign key from Contract table
);


-- 7) Create Manager Table
CREATE TABLE MANAGERS
(
    manager_id              INT                 PRIMARY KEY,
    manager_name            VARCHAR(100),
    manager_dob             date,
    manager_age             INT,
    contract_id             INT                                     -- foreign key from Contract table
);
-- Need to put View for age, drieved attribute


-- 8) Create Contract Table

CREATE TABLE CONTRACT
(
    contract_id             INT                 PRIMARY KEY,
    contract_expiration     DATE,
    wage                    INT
);




/* 
    ************************************************* 
                    Add Foreign Keys
    *************************************************
*/

-- 1) Adding foreigne keys to TEAM Table
ALTER TABLE TEAM
ADD FOREIGN KEY (captain_id) 
REFERENCES PLAYER(player_id)
deferrable initially deferred;                                     -- Add caption foreignkey in Teams table

ALTER TABLE TEAM
ADD FOREIGN KEY (manager_id) 
REFERENCES MANAGERS(manager_id)
deferrable initially deferred;                                     -- Add manager foreignkey in Teams table

ALTER TABLE TEAM
ADD FOREIGN KEY (stadium_id) 
REFERENCES STADIUM(stadium_id);                                     -- Add stadium foreignkey in Teams table



-- 2) Adding foreign key to Player
ALTER TABLE PLAYER
ADD FOREIGN KEY (team_id) 
REFERENCES TEAM(team_id);                                           -- Add team foreignkey in player table

ALTER TABLE PLAYER
ADD FOREIGN KEY (attribute_id) 
REFERENCES PLAYER_ATTRIBUTE(attribute_id)
deferrable initially deferred;                                      -- Add attribute foreignkey in player table

ALTER TABLE PLAYER
ADD FOREIGN KEY (contract_id) 
REFERENCES CONTRACT(contract_id)
deferrable initially deferred;                                      -- Add contract foreignkey in player table


-- 3) Adding foreign key to PLAYER_ATTRIBUTE
ALTER TABLE PLAYER_ATTRIBUTE
ADD FOREIGN KEY (player_id) 
REFERENCES PLAYER(player_id);                                       -- Add player_id foreignkey in PLAYER table

-- 4) Adding foreign key to GK_ATTRIBUTES
ALTER TABLE GK_ATTRIBUTES
ADD FOREIGN KEY (attribute_id) 
REFERENCES PLAYER_ATTRIBUTE(attribute_id);                          -- Add attribute foreignkey in GK_Attribute table



-- 5) Adding foreign key to GK_ATTRIBUTES
ALTER TABLE PL_ATTRIBUTES
ADD FOREIGN KEY (attribute_id) 
REFERENCES PLAYER_ATTRIBUTE(attribute_id);                          -- Add attribute foreignkey in PL_ATTRIBUTES table



-- 6) Adding foreign key to Achievement
ALTER TABLE ACHIEVEMENT
ADD FOREIGN KEY (FA_winner) 
REFERENCES TEAM(team_id);                                           -- Add attribute foreignkey in ACHIEVEMENT table

ALTER TABLE ACHIEVEMENT
ADD FOREIGN KEY (PL_Winner) 
REFERENCES TEAM(team_id);                                           -- Add attribute foreignkey in ACHIEVEMENT table


-- 7) Adding foreign key to player_sponsor
ALTER TABLE PLAYER_SPONSOR
ADD FOREIGN KEY (player_id) 
REFERENCES PLAYER(player_id);                                       -- Add player foreignKey in PLAYER_SPONSOR table


-- 8) Adding foreign key to team_sponsor
ALTER TABLE TEAM_SPONSOR
ADD FOREIGN KEY (team_id) 
REFERENCES TEAM(team_id);                                           -- Add team foreignKey in TEAM_SPONSOR table


-- 9) Adding foreign key to Staff
ALTER TABLE STAFF
ADD FOREIGN KEY (team_id) 
REFERENCES TEAM(team_id);                                           -- Add team foreignKey in STAFF table

ALTER TABLE STAFF
ADD FOREIGN KEY (contract_id) 
REFERENCES CONTRACT(contract_id);                                   -- Add contract foreignKey in STAFF table


-- 10) Adding foreign key to Manager
ALTER TABLE MANAGERS                                                
ADD FOREIGN KEY (contract_id)
REFERENCES CONTRACT(contract_id);                                   -- Add contract foreignKey in MANAGERS table





/* 
    ************************************************* 
              ADDING INDEXES IN TO COLUMNS
    *************************************************
*/


-- Indexes are added only to columns that we think will be accessed more often

CREATE INDEX contract_exp_index on CONTRACT(CONTRACT_EXPIRATION);
CREATE INDEX player_composite_index on PLAYER(PLAYER_NAME, PLAYER_AGE, PLAYING_POSITION);
CREATE INDEX team_name_index on TEAM(TEAM_NAME);
CREATE INDEX manager_composite_index on MANAGERS(MANAGER_NAME, MANAGER_AGE);




/* 
    ************************************************* 
                    Inserting Data
    *************************************************
*/

-- We have cyclic foreign key, which means table A's primary key is in table B and table B's primary key is in table A.
-- Therefore, if we insert data in A it will throw error that foreign key in B doesnot exist and if we insert data in B, it 
-- will throw error that foreign key in A doesnot exist.

-- The work around for this problem is to use 'deferrable constraint'. Deferrable constraints are checked when the transaction is completed
-- rather then after each INSERT statement.




-- 1) INSERTING Stadium

INSERT INTO 
    STADIUM
        (stadium_id, stadium_name, stadium_capacity)
    VALUES
        (1, 'Stamford Bridge', 41837);                             -- Chelsea

INSERT INTO    
    STADIUM
        (stadium_id, stadium_name, stadium_capacity)
    VALUES
        (2, 'Old Trafford', 74140);                                -- Man. United

INSERT INTO       
    STADIUM
        (stadium_id, stadium_name, stadium_capacity)
    VALUES
        (3, 'Etihad Stadium', 55017);                              -- Man. City

INSERT INTO     
    STADIUM
        (stadium_id, stadium_name, stadium_capacity)
    VALUES
        (4, 'Anfield', 53394);                                     -- Liverpool

INSERT INTO 
    STADIUM
        (stadium_id, stadium_name, stadium_capacity)
    VALUES
        (5, 'Emirates Stadium', 60260);                            -- Arsenal
    


-- 2) INSERTING Contracts

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (1, TO_DATE('01/12/2022', 'DD/MM/YYYY'), 75000);                -- Tuchel (chelsea's Manager)
    

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (6, TO_DATE('01/12/2024', 'DD/MM/YYYY'), 145000);                -- Azpilicueta (chelsea's Captain)
    


INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (2, TO_DATE('01/12/2023', 'DD/MM/YYYY'), 160000);               -- Ole  (Man U's Manager)
    
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (7, TO_DATE('01/12/2025', 'DD/MM/YYYY'), 190000);               -- Maguire (Man U's Captain)
    
        
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (3, TO_DATE('01/12/2021', 'DD/MM/YYYY'), 417500);               -- Pep (Man C's Manager)
 
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (8, TO_DATE('01/12/2022', 'DD/MM/YYYY'), 150000);               -- Fernandinho (Man C's Captain)
    

   
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (4, TO_DATE('01/12/2024', 'DD/MM/YYYY'), 313500);               -- Klopp (Liverpool's Manager)

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (9, TO_DATE('01/12/2027', 'DD/MM/YYYY'), 100000);               -- Henderson (Liverpool's Captain)
    

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (5, TO_DATE('01/12/2024', 'DD/MM/YYYY'), 105000);               -- Arteta (Arsenal's Manager)
 
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (10, TO_DATE('01/12/2024', 'DD/MM/YYYY'), 250000);               -- Aubameyang (Arsenal's Captain) 
 
 
 
       
-- 3) INSERTING Teams, Captains and Managers (Cyclic Foreign keys)

--BEGIN 

INSERT into TEAM 
  (team_id, team_name, city, president, captain_id, manager_id, stadium_id) 
VALUES 
  (1, 'Chelsea', 'London', 'Roman Arkadyevich Abramovich', 1, 1, 1);
  
INSERT into TEAM 
  (team_id, team_name, city, president, captain_id, manager_id, stadium_id) 
VALUES 
  (2, 'Man United', 'Manchester', 'Ed Woodward', 2, 2, 2);

INSERT into TEAM 
  (team_id, team_name, city, president, captain_id, manager_id, stadium_id) 
VALUES 
  (3, 'Man City', 'Manchester', 'Ferran Soriano', 3, 3, 3);

INSERT into TEAM 
  (team_id, team_name, city, president, captain_id, manager_id, stadium_id) 
VALUES 
  (4, 'Liverpool', 'Liverpool', 'Michael S. Gordon', 4, 4, 4);

INSERT into TEAM 
  (team_id, team_name, city, president, captain_id, manager_id, stadium_id) 
VALUES 
  (5, 'Arsenal', 'London', 'Stan Kroenke', 5, 5, 5);



-- Managers

INSERT into MANAGERS 
  (manager_id, manager_name, manager_dob, manager_age, contract_id) 
VALUES 
  (1, 'Thomas Tuchel', TO_DATE('29/08/1973', 'DD/MM/YYYY'), 47, 1);


INSERT into MANAGERS 
  (manager_id, manager_name, manager_dob, manager_age, contract_id) 
VALUES 
  (2, 'Ole Gunnar Solskjær', TO_DATE('26/02/1973', 'DD/MM/YYYY'), 48, 2);


INSERT into MANAGERS 
  (manager_id, manager_name, manager_dob, manager_age, contract_id) 
VALUES 
  (3, 'Pep Guardiola', TO_DATE('18/01/1971', 'DD/MM/YYYY'), 50, 3);


INSERT into MANAGERS 
  (manager_id, manager_name, manager_dob, manager_age, contract_id) 
VALUES 
  (4, 'Jürgen Klopp', TO_DATE('16/06/1967', 'DD/MM/YYYY'), 54, 4);


INSERT into MANAGERS 
  (manager_id, manager_name, manager_dob, manager_age, contract_id) 
VALUES 
  (5, 'Mikel Arteta', TO_DATE('26/03/1982', 'DD/MM/YYYY'), 39, 5);


-- Captains

INSERT INTO PLAYER                                                  -- Chelsea's Captain
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(1, 'César Azpilicueta', TO_DATE('28/08/1989', 'DD/MM/YYYY'), 31, 'centre-back', 28, 'Spanish', 1, 1, 6);


INSERT INTO PLAYER                                                  -- MANU's Captain
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(2, 'Harry Maguire', TO_DATE('05/03/1993', 'DD/MM/YYYY'), 28, 'centre-back', 6, 'English', 2, 2, 7);


INSERT INTO PLAYER                                                  -- MANC's Captain
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(3, 'Fernandinho', TO_DATE('04/04/1985', 'DD/MM/YYYY'), 36, 'midfielder', 25, 'Brazilian', 3, 3, 8);


INSERT INTO PLAYER                                                  -- Liverpool's Captain
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(4, 'Jordan Henderson', TO_DATE('17/06/1990', 'DD/MM/YYYY'), 14, 'midfielder', 31, 'English', 4, 4, 9);


INSERT INTO PLAYER                                                  -- Arsenal's Captain
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(5, 'Pierre-Emerick Aubameyang', TO_DATE('18/06/1989', 'DD/MM/YYYY'), 14, 'striker', 32, 'French', 5, 5, 10);



-- Captains Attributes

INSERT INTO PLAYER_ATTRIBUTE                                        -- Chelsea's Azpilicueta
(attribute_id, player_id)
values
(1,1);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(1, 1, 7,7,6,7,8);                                                  



INSERT INTO PLAYER_ATTRIBUTE                                        -- Manu's Harry
(attribute_id, player_id)
values
(2,2);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(2, 2, 7,7,6,7,8);                                                 




INSERT INTO PLAYER_ATTRIBUTE                                        -- Manc's Fernandinho
(attribute_id, player_id)
values
(3,3);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(3, 3, 8,7,6,8,7);


INSERT INTO PLAYER_ATTRIBUTE                                        -- Liverpool's Henderson
(attribute_id, player_id)
values
(4,4);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(4, 4, 6,8,6,8,8);


INSERT INTO PLAYER_ATTRIBUTE                                        -- Arsenal's Aubameyang
(attribute_id, player_id)
values
(5,5);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(5, 5, 9,7,6,6,7);


-- Insert remaining players into the teams


-- Insert chelsea players

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (11, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- Kanté (chelsea) 
 
INSERT INTO PLAYER                                                   -- Kante (chelsea)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(6, 'N-Golo Kanté', TO_DATE('29/03/1991', 'DD/MM/YYYY'), 30, 'central midfielder', 13, 'French', 1, 6, 11);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Kanté (chelsea)
(attribute_id, player_id)
values
(6,6);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(6, 6, 9,8,7,8,8);




INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (12, TO_DATE('01/06/2022', 'DD/MM/YYYY'), 120000);               -- Silva  (chelsea) 
 

INSERT INTO PLAYER                                                   -- Silva  (chelsea)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(7, 'Thiago Silva', TO_DATE('22/09/1984', 'DD/MM/YYYY'), 36, 'centre back', 6, 'Brazilian', 1, 7, 12);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Silva  (chelsea)
(attribute_id, player_id)
values
(7,7);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(7, 7, 6,7,6,7,8);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (13, TO_DATE('01/06/2025', 'DD/MM/YYYY'), 117000);               -- Timo Werner  (chelsea) 

INSERT INTO PLAYER                                                   -- Timo Werner  (chelsea)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(8, 'Timo Werner', TO_DATE('06/03/1996', 'DD/MM/YYYY'), 25, 'forward ', 1, 'German', 1, 8, 13);
 

INSERT INTO PLAYER_ATTRIBUTE                                         -- Timo Werner  (chelsea)
(attribute_id, player_id)
values
(8,8);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(8, 8, 6,7,6,7,7);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (14, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- Kepa  (chelsea) 
 

INSERT INTO PLAYER                                                   -- Kepa  (chelsea)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(9, 'Kepa Arrizabalaga', TO_DATE('03/10/1994', 'DD/MM/YYYY'), 26, 'goalkeeper', 1, 'Spanish', 1, 9, 14);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Kepa  (chelsea)
(attribute_id, player_id)
values
(9,9);

INSERT INTO GK_ATTRIBUTES
(gk_attribute_id, attribute_id, GK_BALL_HANDLING, GK_REFLEXES, LEADERSHIP, SHOOTING)
VALUES
(1, 9, 7,6,4,8);




-- Insert Manchester United Players

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (15, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 220000);               -- Pogba (Manu) 
 
INSERT INTO PLAYER                                                   -- Pogba (Manu)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(10, 'Paul Pogba', TO_DATE('15/03/1993', 'DD/MM/YYYY'), 28, 'central midfielder', 6, 'French', 2, 10, 15);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Pogba (Manu)
(attribute_id, player_id)
values
(10,10);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(10, 10, 7,8,8,9,7);




INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (16, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- Rashford (Manu) 
 
INSERT INTO PLAYER                                                   -- Rashford (Manu)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(11, 'Marcus Rashford', TO_DATE('31/10/1997', 'DD/MM/YYYY'), 23, 'forward ', 11, 'English', 2, 11, 16);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Rashford (Manu)
(attribute_id, player_id)
values
(11,11);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(11, 11, 9,7,6,6,5);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (17, TO_DATE('01/12/2024', 'DD/MM/YYYY'), 120000);               -- Martial (Manu) 
 
INSERT INTO PLAYER                                                   -- Martial (Manu)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(12, 'Anthony Martial', TO_DATE('5/12/1995', 'DD/MM/YYYY'), 25, 'forward ', 9, 'French', 2, 12, 17);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Martial (Manu)
(attribute_id, player_id)
values
(12,12);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(12, 12, 8,7,7,6,6);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (18, TO_DATE('01/12/2023', 'DD/MM/YYYY'), 130000);               -- Cavani  (Manu) 
 
INSERT INTO PLAYER                                                   -- Cavani  (Manu)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(13, 'Edinson Cavani', TO_DATE('14/02/1987', 'DD/MM/YYYY'), 34, 'forward', 7, 'Uruguayan', 2, 13, 18);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Cavani  (Manu)
(attribute_id, player_id)
values
(13,13);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(13, 13, 6,7,6,6,5);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (19, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- de Gea  (Manu) 
 

INSERT INTO PLAYER                                                   -- de Gea  (Manu)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(14, 'David de Gea', TO_DATE('07/11/1990', 'DD/MM/YYYY'), 30, 'goalkeeper', 1, 'Spanish', 2, 14, 19);


INSERT INTO PLAYER_ATTRIBUTE                                         -- de Gea  (Manu)
(attribute_id, player_id)
values
(14,14);

INSERT INTO GK_ATTRIBUTES
(gk_attribute_id, attribute_id, GK_BALL_HANDLING, GK_REFLEXES, LEADERSHIP, SHOOTING)
VALUES
(2, 14, 7,6,4,8);



-- Insert players for Manchester City

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (20, TO_DATE('01/12/2025', 'DD/MM/YYYY'), 170000);               -- Sterling  (Manc) 
 
INSERT INTO PLAYER                                                   -- Sterling  (Manc)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(15, 'Raheem Sterling', TO_DATE('08/12/1994', 'DD/MM/YYYY'), 26, 'winger', 10, 'English', 3, 15, 20);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Sterling  (Manc)
(attribute_id, player_id)
values
(15,15);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(15, 15, 7,8,8,8,7);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (21, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 190000);               -- De Bruyne  (Manc) 
 
INSERT INTO PLAYER                                                   -- De Bruyne  (Manc)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(16, 'Kevin De Bruyne', TO_DATE('28/06/1991', 'DD/MM/YYYY'), 30, 'midfielder', 17, 'Belgium', 3, 16, 21);


INSERT INTO PLAYER_ATTRIBUTE                                         -- De Bruyne  (Manc)
(attribute_id, player_id)
values
(16,16);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(16, 16, 7,8,8,9,8);




INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (22, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 190000);               -- Mahrez  (Manc) 

 
INSERT INTO PLAYER                                                   -- Mahrez  (Manc)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(17, 'Riyad Mahrez', TO_DATE('21/02/1991', 'DD/MM/YYYY'), 26, 'midfielder', 17, 'Algerian', 3, 17, 22);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Mahrez  (Manc)
(attribute_id, player_id)
values
(17,17);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(17, 17, 7,8,8,9,8);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (23, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- Ederson   (Manc) 
 

INSERT INTO PLAYER                                                   -- Ederson   (Manc)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(18, 'Ederson Santana de Moraes', TO_DATE('17/08/1993', 'DD/MM/YYYY'), 27, 'goalkeeper', 1, 'Brazilian', 3, 18, 23);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Ederson   (Manc)
(attribute_id, player_id)
values
(18,18);

INSERT INTO GK_ATTRIBUTES
(gk_attribute_id, attribute_id, GK_BALL_HANDLING, GK_REFLEXES, LEADERSHIP, SHOOTING)
VALUES
(3, 14, 7,6,4,8);




-- Insert players for Liverpool


INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (24, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 200000);               -- Salah  (Liverpool) 

 
INSERT INTO PLAYER                                                   -- Salah  (Liverpool)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(19, 'Mohamed Salah', TO_DATE('15/06/1992', 'DD/MM/YYYY'), 29, 'forward ', 11, 'Egyptian', 4, 19, 24);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Salah  (Liverpool)
(attribute_id, player_id)
values
(19,19);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(19, 19, 8,9,8,8,7);



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (25, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 170000);               -- van Dijk  (Liverpool) 

 
INSERT INTO PLAYER                                                   -- van Dijk  (Liverpool)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(20, 'Virgil van Dijk', TO_DATE('08/07/1991', 'DD/MM/YYYY'), 30, 'centre-back', 4, 'Netherlands', 4, 20, 25);


INSERT INTO PLAYER_ATTRIBUTE                                         -- van Dijk  (Liverpool)
(attribute_id, player_id)
values
(20,20);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(20, 20, 9,8,6,8,9);





INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (26, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 170000);               -- Mané  (Liverpool) 

 
INSERT INTO PLAYER                                                   -- Mané  (Liverpool)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(21, 'Sadio Mané', TO_DATE('10/04/1992', 'DD/MM/YYYY'), 29, 'winger', 10, 'Senegal', 4, 21, 26);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Mané (Liverpool)
(attribute_id, player_id)
values
(21,21);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(21, 21, 9,8,7,7,7);




INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (27, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- Alisson   (Liverpool) 

INSERT INTO PLAYER                                                   -- Alisson    (Liverpool)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(22, 'Alisson Becker', TO_DATE('02/10/1992', 'DD/MM/YYYY'), 28, 'goalkeeper', 1, 'Brazilian', 4, 22, 27);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Alisson   (Liverpool)
(attribute_id, player_id)
values
(22,22);

INSERT INTO GK_ATTRIBUTES
(gk_attribute_id, attribute_id, GK_BALL_HANDLING, GK_REFLEXES, LEADERSHIP, SHOOTING)
VALUES
(4, 22, 7,6,4,8);




-- Insert players for Arsenal


INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (28, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 130000);               -- White  (Arsenal) 

 
INSERT INTO PLAYER                                                   -- White  (Arsenal)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(23, 'Ben White', TO_DATE('08/10/1997', 'DD/MM/YYYY'), 23, 'centre-back', 4, 'English', 5, 23, 28);


INSERT INTO PLAYER_ATTRIBUTE                                         -- White (Arsenal)
(attribute_id, player_id)
values
(23,23);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(23, 23, 8,7,6,6,6);





INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (29, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 110000);               -- Saka  (Arsenal) 

 
INSERT INTO PLAYER                                                   -- Saka  (Arsenal)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(24, 'Bukayo Saka', TO_DATE('05/09/2001', 'DD/MM/YYYY'), 19, 'winger', 7, 'English', 5, 24, 29);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Saka (Arsenal)
(attribute_id, player_id)
values
(24,24);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(24, 24, 8,7,6,6,6);




INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (30, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 110000);               -- Xhaka  (Arsenal) 

 
INSERT INTO PLAYER                                                   -- Xhaka  (Arsenal)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(25, 'Granit Xhaka', TO_DATE('27/09/1992', 'DD/MM/YYYY'), 28, 'midfielder', 34, 'Switzerland', 5, 25, 30);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Xhaka (Arsenal)
(attribute_id, player_id)
values
(25,25);

INSERT INTO PL_ATTRIBUTES
(pl_attribute_id, attribute_id, speed, ball_control, dribbling, passing_accuracy, positioning)
VALUES
(25, 25, 8,7,6,6,6);





INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (31, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 120000);               -- Bernd Leno    (Arsenal) 

INSERT INTO PLAYER                                                   -- Bernd Leno    (Arsenal)
(player_id, player_name, player_dob, player_age, playing_position, player_jerseyNo, player_nationality, team_id, attribute_id, contract_id)
VALUES
(26, 'Bernd Leno', TO_DATE('04/03/1992', 'DD/MM/YYYY'), 29, 'goalkeeper', 1, 'German', 5, 26, 31);


INSERT INTO PLAYER_ATTRIBUTE                                         -- Bernd Leno    (Arsenal)
(attribute_id, player_id)
values
(26,26);

INSERT INTO GK_ATTRIBUTES
(gk_attribute_id, attribute_id, GK_BALL_HANDLING, GK_REFLEXES, LEADERSHIP, SHOOTING)
VALUES
(5, 26, 7,6,4,8);



COMMIT;
--END;
    





-- Inserting Staff and their contract

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (32, TO_DATE('01/12/2022', 'DD/MM/YYYY'), 27000);               -- Staff Chelsea 
 
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (33, TO_DATE('01/12/2021', 'DD/MM/YYYY'), 22000);               -- Staff Chelsea 
  
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (34, TO_DATE('01/12/2021', 'DD/MM/YYYY'), 22000);               -- Staff Chelsea 

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (35, TO_DATE('01/12/2023', 'DD/MM/YYYY'), 50000);               -- Staff Chelsea 


INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (1, 'Eva Carneiro', 'Medical', 1, 32);                           -- Staff Chelsea 

INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (2, 'Dimitris Kalogiannidis', 'Medical', 1, 33);                 -- Staff Chelsea 

INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (3, 'Jason Palmer', 'Medical', 1, 34);                           -- Staff Chelsea 

INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (4, 'Jody Morris', 'Coach', 1, 35);                              -- Staff Chelsea 



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (36, TO_DATE('01/06/2023', 'DD/MM/YYYY'), 43000);               -- Staff Manu 
  
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (37, TO_DATE('01/01/2023', 'DD/MM/YYYY'), 27000);               -- Staff Manu 

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (38, TO_DATE('01/01/2023', 'DD/MM/YYYY'), 32000);               -- Staff Manu 


INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (5, 'Rod Thornley', 'Medical', 2, 36);                          -- Staff Manu 

INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (6, 'Jos van Dijk', 'Medical', 2, 37);                          -- Staff Manu 

INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (7, 'Eric Ramsay', 'Coach', 2, 38);                             -- Staff Manu 



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (39, TO_DATE('01/06/2023', 'DD/MM/YYYY'), 23000);               -- Staff Mcity 
  
INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (40, TO_DATE('01/01/2023', 'DD/MM/YYYY'), 26000);               -- Staff Mcity 



INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (8, 'Eduardi Mauri', 'Medical', 3, 39);                         -- Staff Mcity

INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (9, 'Steve Sparks', 'Medical', 3, 40);                          -- Staff Mcity 



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (41, TO_DATE('01/04/2022', 'DD/MM/YYYY'), 31000);               -- Staff Liverpool 


INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (42, TO_DATE('01/12/2021', 'DD/MM/YYYY'), 55000);               -- Staff Liverpool 
    

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (43, TO_DATE('01/09/2023', 'DD/MM/YYYY'), 37000);               -- Staff Liverpool 
    
    
INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (10, 'Andrew Massey', 'Medical', 4, 41);                         -- Staff Liverpool


INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (11, 'Dr Jim Moxon', 'Medical', 4, 42);                          -- Staff Liverpool


INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (12, 'Pepijn Lijnders', 'Coach', 4, 43);                         -- Staff Liverpool



INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (44, TO_DATE('01/01/2024', 'DD/MM/YYYY'), 31000);                -- Staff Arsenal 


INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (45, TO_DATE('01/11/2025', 'DD/MM/YYYY'), 55000);                -- Staff Arsenal 
    

INSERT INTO CONTRACT
    (contract_id, contract_expiration, wage)
VALUES
    (46, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 37000);                -- Staff Arsenal 
    
    
INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (13, 'Jordan Reece', 'Medical', 5, 44);                          -- Staff Arsenal


INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (14, 'Richard Allison', 'Medical', 5, 45);                       -- Staff Arsenal


INSERT INTO STAFF
    (staff_id, staff_member_name, staff_type, team_id, contract_id)
VALUES
    (15, 'Albert Stuivenberg', 'Coach', 5, 46);                      -- Staff Arsenal





-- Inserting into Achievement

INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2015, 1, 5);
    
    
INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2014, 3, 5);
    

INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2012, 3, 1);
    
    
INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2011, 2, 3);


INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2010, 1, 1);


INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2009, 2, 1);
    

INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2007, 2, 1);
    

INSERT INTO ACHIEVEMENT
    (title_year, pl_winner, fa_winner)
VALUES
    (2006, 1, 4);  





-- Insert into Team_Sponsor Table

-- Chelsea sponsor
INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (1,1,'Three');                                                          

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (2,1,'nike');


-- Man. United sponsors
INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (3,2,'adidas');

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (4,2,'Chevrolet');

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (5,2,'DHL'); 


-- Man. City sponsors
INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (6,3,'Etihad Airways');

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (7,3,'PUMA');

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (8,3,'Nissan');

    
-- Liverpool sponsor
INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (9,4,'Standard Chartered');

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (10,4,'nike');


-- Arsenal sponsor
INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (11,5,'Emirates');

INSERT INTO TEAM_SPONSOR
    (SPONSOR_ID, TEAM_ID, SPONSOR_NAME)
VALUES
    (12,5,'adidas');
    



-- Insert into Player_Sponsor Table

INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (1, 2, 'nike');                                             -- Maguire (Manu)
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (2, 2, 'puma');                                             -- Maguire (Manu)

INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (3, 3, 'puma');                                             -- Fernandinho (Manc)
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (4, 4, 'MaxiNutrition');                                    -- Jordan Henderson (Liverpool)
    

INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (5, 5, 'nike');                                             -- Pierre-Emerick Aubameyang (Arsenal)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (6, 6, 'adidas');                                           -- N-Golo Kanté (Chelsea)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (7, 10, 'adidas');                                           -- Pogba (Manu)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (8, 10, 'PepsiCo');                                          -- Pogba (Manu)


INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (9, 10, 'TCL');                                              -- Pogba (Manu)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (10, 11, 'nike');                                            -- Rashford (Manu)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (11, 14, 'adidas');                                          -- De Gea (Manu)
    

INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (12, 15, 'New Balance');                                     -- Sterling (Manc)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (13, 16, 'EA SPORTS');                                       -- Bruyne (Manc)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (14, 17, 'nike');                                            -- Riyad Mahrez (Manc)
    

INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (15, 19, 'adidas');                                           -- Salah (Liverpool)
   
   
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (16, 20, 'EA Sports');                                        -- Virgil van Dijk (Liverpool)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (17, 20, 'nike');                                             -- Virgil van Dijk (Liverpool)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (18, 21, 'New Balance');                                      -- Mane (Liverpool)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (19, 22, 'nike');                                             -- Alisson (Liverpool)
    
    
INSERT INTO PLAYER_SPONSOR
    (SPONSOR_ID, PLAYER_ID, SPONSOR_NAME)
VALUES
    (20, 25, 'Under Armour');                                     -- Xhaka (Arsenal)




/* 
    ************************************************* 
                    FINAL QUERIES
    *************************************************
*/

-- 1) Select players from specific team (Manchester City) whose contracts would be expiring this year. (This query would be useful for player contract renewals)
SELECT P.PLAYER_NAME, P.PLAYER_AGE, P.PLAYING_POSITION, C.CONTRACT_EXPIRATION from PLAYER P JOIN CONTRACT C ON (P.CONTRACT_ID = C.CONTRACT_ID) WHERE P.TEAM_ID = 3 AND C.CONTRACT_EXPIRATION < TO_DATE('12/12/2022', 'DD/MM/YYYY');

-- 2) Select players who are strikers and their age is above 30. (This query would be useful to check if a club needs to buy a new player)
SELECT PLAYER_NAME, PLAYER_AGE, PLAYING_POSITION from PLAYER where PLAYING_POSITION = 'forward' AND PLAYER_AGE > 30;

-- 3) Get Player_name, age and passing_accuracy that plays in midfield for for specific team. (This query would be useful to get insights on players attributes)
SELECT P.PLAYER_NAME, P.PLAYER_AGE, A.PASSING_ACCURACY FROM PLAYER P, PL_ATTRIBUTES A WHERE P.TEAM_ID = 3 AND P.PLAYING_POSITION = 'midfielder' AND P.ATTRIBUTE_ID = A.ATTRIBUTE_ID;

-- 4) Get team_name with the most PL wins (in this available record)
SELECT T.TEAM_NAME, R.most_pl_wins FROM TEAM T, (SELECT PL_WINNER, COUNT(*) as Most_pl_wins FROM achievement GROUP BY PL_WINNER FETCH FIRST 1 ROWS ONLY) R where R.PL_WINNER = T.TEAM_ID;

-- 5) Get Manager contract that will expire within next year. (This query would be useful for manager contract renewals)
SELECT M.MANAGER_NAME, M.MANAGER_AGE, C.CONTRACT_EXPIRATION FROM MANAGERS M INNER JOIN CONTRACT C on (M.CONTRACT_ID = C.CONTRACT_ID) and C.CONTRACT_EXPIRATION < TO_DATE('12/12/2022', 'DD/MM/YYYY');

-- 6) Get the total of medical and coaches staff in specific team (Chelsea) (This query would be useful to reinforce the staff team that has less members
SELECT STAFF_TYPE, COUNT(*) as Total_members from STAFF where TEAM_ID = 1 GROUP BY STAFF_TYPE;

-- 7) Get PL and FA cup winners from a specific year (2014)
SELECT T1.TEAM_NAME as PL_WINNER, T2.TEAM_NAME, R.TITLE_YEAR as FA_WINNER FROM TEAM T1, TEAM T2, (SELECT TITLE_YEAR, FA_WINNER, PL_WINNER FROM ACHIEVEMENT WHERE TITLE_YEAR = 2014) R where R.pl_winner = T1.Team_ID AND R.fa_winner = T2.team_id;

-- 8) Get all sponsors for single specific team (Manchester United)
SELECT S.SPONSOR_NAME, T.TEAM_NAME FROM TEAM T, TEAM_SPONSOR S WHERE S.TEAM_ID = T.TEAM_ID AND T.TEAM_ID = 2;

-- 9) Get players from specific team (Liverpool) with wages > 150000/week (This query would be useful to get to know teams wages distribution)
SELECT P.PLAYER_NAME, P.PLAYER_AGE, C.WAGE from PLAYER P, CONTRACT C WHERE P.TEAM_ID = 4 AND P.CONTRACT_ID = C.CONTRACT_ID AND C.WAGE > 150000;

-- 10) Get list of players with no sponsors
SELECT P.PLAYER_NAME, T.TEAM_NAME FROM PLAYER P, TEAM T WHERE P.TEAM_ID = T.TEAM_ID AND P.PLAYER_ID NOT IN (SELECT PLAYER_ID FROM PLAYER_SPONSOR);
