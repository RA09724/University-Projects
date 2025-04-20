CREATE TABLE Authors (
    AuthorID NVARCHAR(50) PRIMARY KEY,
    Author NVARCHAR(255) NOT NULL
);


CREATE TABLE Genres (
    GenreID NVARCHAR(50) PRIMARY KEY,
    Genre NVARCHAR(255) NOT NULL
);


CREATE TABLE Publishers (
    PublisherID NVARCHAR(50) PRIMARY KEY,
    Publisher NVARCHAR(255) NOT NULL,
    PublisherAddress NVARCHAR(255) NOT NULL
);


CREATE TABLE Categories (
    CategoryID NVARCHAR(50) PRIMARY KEY,
    Category NVARCHAR(255) NOT NULL,
    CategoryDescription NVARCHAR(255) NOT NULL,
    CategoryFine DECIMAL (10,2) NOT NULL
);


CREATE TABLE States (
    StateID NVARCHAR(50) PRIMARY KEY,
    State NVARCHAR(255) NOT NULL
);


CREATE TABLE Books (
    BookID NVARCHAR(50) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    BookCost INT NOT NULL,
    ISBNNumber NVARCHAR(50) NOT NULL,
    CategoryID NVARCHAR(50),
    GenreID NVARCHAR(50),
    AuthorID NVARCHAR(50),
    PublisherID NVARCHAR(50),
    BookDescription NVARCHAR(255) NOT NULL,
    QuantityOfCopies INT NOT NULL,
    QuantityOfCopiesAvailable INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);


CREATE TABLE Members (
    MemberID NVARCHAR(50) PRIMARY KEY,
    FirstName NVARCHAR(255) NOT NULL,
    LastName NVARCHAR(255) NOT NULL,
    StateID NVARCHAR(50),
    ContactNumber NVARCHAR(50) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    NumberOfOverdues INT NOT NULL,
    NumberOfOverduesPaid INT NOT NULL,
    FOREIGN KEY (StateID) REFERENCES States(StateID)
);


CREATE TABLE Loans (
    LoanID NVARCHAR(50) PRIMARY KEY,
    MemberID NVARCHAR(50),
    BookID NVARCHAR(50),
    BorrowDate DATETIME NOT NULL,
    ReturnDate DATETIME,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);


CREATE TABLE Fines (
    FineID NVARCHAR(50) PRIMARY KEY,
    MemberID NVARCHAR(50),
    LoanID NVARCHAR(50),
    OverdueDays INT NOT NULL,
    TotalFine DECIMAL(10,2) NOT NULL,
    Cleared CHAR(3) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);


CREATE TABLE Rooms (
	RoomID NVARCHAR(50) PRIMARY KEY,
	RoomName NVARCHAR (50) NOT NULL
);
	

CREATE TABLE RoomReservations (
	RoomReservationID NVARCHAR(50) PRIMARY KEY,
    RoomID NVARCHAR(50),
    MemberID NVARCHAR(50), 
    RoomReservationDate DATETIME NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
	FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);


CREATE TABLE BookReservations (
    ReservationID NVARCHAR(50) PRIMARY KEY,
    BookID NVARCHAR(50),
    MemberID NVARCHAR(50),
    ReservationDate DATETIME NOT NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);


INSERT INTO Authors (AuthorID, Author) 
VALUES 
    ('AU001', 'James Clear'),
    ('AU002', 'Yuval Noah Harari'),
    ('AU003', 'Rani Manicka'),
    ('AU004', 'Sarah Blackwood'),
    ('AU005', 'Aria Nightshade'),
    ('AU006', 'Suzanne Collins'),
    ('AU007', 'Sheridan Titman');


INSERT INTO Genres (GenreID, Genre) 
VALUES 
    ('G01', 'Self-help'),
    ('G02', 'History'),
    ('G03', 'Romance'),
    ('G04', 'Horror'),
    ('G05', 'Fantasy'),
    ('G06', 'Action'),
    ('G07', 'Finance');


INSERT INTO Publishers (PublisherID, Publisher, PublisherAddress) 
VALUES 
    ('PB01', 'Penguin Random House', '1745 Broadway, New York, NY 10019, USA'),
    ('PB02', 'James Clear Publishing', '123 Main Street, Columbus, OH 43215, USA'),
    ('PB03', 'HarperCollins', '195 Broadway, New York, NY 10007, USA'),
    ('PB04', 'Penguin Books', '80 Strand, London, WC2R 0RL, United Kingdom'),
    ('PB05', 'Mystic Moon Press', '456 Oak Street, Suite 200, Chicago, IL 60611, USA'),
    ('PB06', 'Midnight Reads', '27 Jalan Raja Chulan, Kuala Lumpur, Malaysia'),
    ('PB07', 'Wiley', '155 Jalan Sultan Abdul Samad, Brickfields, 50470 Kuala Lumpur, Malaysia'),
    ('PB08', 'Scholastic Press', '557 Broadway, New York City, United States');



INSERT INTO Categories (CategoryID, Category, CategoryDescription, CategoryFine) 
VALUES 
    ('C1', 'Green', 'Can be loaned for 4 weeks.', 0.5),
    ('C2', 'Yellow', 'Can be loaned for 2 weeks.', 0.3),
    ('C3', 'Red', 'Cannot be loaned (Reference books, Journals & Student Projects)', 0);


INSERT INTO States (StateID, State) 
VALUES 
    ('S01', 'Johor'),
    ('S02', 'Kedah'),
    ('S03', 'Kelantan'),
    ('S04', 'Malacca'),
    ('S05', 'Negeri Sembilan'),
    ('S06', 'Pahang'),
    ('S07', 'Perak'),
    ('S08', 'Perlis'),
    ('S09', 'Penang'),
    ('S10', 'Sabah'),
    ('S11', 'Sarawak'),
    ('S12', 'Selangor'),
    ('S13', 'Terengganu'),
    ('S14', 'Kuala Lumpur'),
    ('S15', 'Labuan'),
    ('S16', 'Putrajaya');




INSERT INTO Books (BookID, Title, BookCost, ISBNNumber, CategoryID, GenreID, AuthorID, PublisherID, BookDescription, QuantityOfCopies, QuantityOfCopiesAvailable)
VALUES 
    ('BK001', 'Atomic Habits', 55, '978-1-23456-789-0', 'C2', 'G01', 'AU001', 'PB01', 'A guide to building good habits and breaking bad ones.', 14, 0),
    ('BK002', 'Transform Your Habits', 40, '978-1-23456-789-1', 'C2', 'G01', 'AU001', 'PB02', 'Strategies for creating lasting behavior changes.', 21, 1),
    ('BK003', 'The Habits Academy', 70, '978-1-23456-789-2', 'C2', 'G01', 'AU001', 'PB02', 'Comprehensive course on building effective habits.', 16, 4),
    ('BK004', 'Mastering Motivation', 60, '978-1-23456-789-3', 'C2', 'G01', 'AU001', 'PB01', 'How to stay motivated to achieve your goals.', 6, 3),
    ('BK005', 'Clear Habits', 50, '978-1-23456-789-4', 'C2', 'G01', 'AU001', 'PB02', 'Practical advice for habit formation and success.', 5, 2),
    ('BK006', 'Sapiens: A Brief History of Humankind', 65, '978-0-12345-678-9', 'C2', 'G02', 'AU002', 'PB03', 'Explores the history of Homo sapiens from the Stone Age to the present.', 9, 2),
    ('BK007', 'Homo Deus: A Brief History of Tomorrow', 70, '978-0-12345-679-0', 'C2', 'G02', 'AU002', 'PB03', 'Examines the future of humanity in terms of technology and society.', 11, 4),
    ('BK008', '21 Lessons for the 21st Century', 60, '978-0-12345-680-6', 'C2', 'G02', 'AU002', 'PB03', 'Addresses current issues and challenges facing humanity in the 21st century.', 10, 2),
    ('BK009', 'The Rice Mother', 50, '978-0-98765-432-1', 'C1', 'G03', 'AU003', 'PB04', 'A captivating family saga set in Malaysia, exploring love, loss, and resilience.', 12, 3),
    ('BK010', 'Touching Earth', 45, '978-0-98765-433-2', 'C1', 'G03', 'AU003', 'PB04', 'A mesmerizing tale of forbidden love and cultural clashes spanning generations.', 13, 3),
    ('BK011', 'The Japanese Lover', 55, '978-0-98765-434-3', 'C1', 'G03', 'AU003', 'PB04', 'A haunting romance set against the backdrop of World War II and its aftermath.', 17, 4),
    ('BK012', 'Black Rice', 60, '978-0-98765-435-4', 'C1', 'G03', 'AU003', 'PB04', 'A gripping narrative of love, betrayal, and redemption, set in both Malaysia and England.', 6, 1),
    ('BK013', 'Whispers in the Shadows', 35, '978-1-234567-89-0', 'C1', 'G04', 'AU004', 'PB06', 'A chilling tale of a haunted mansion and the secrets it holds.', 7, 4),
    ('BK014', 'Echoes of the Forgotten', 40, '978-0-987654-32-1', 'C1', 'G04', 'AU004', 'PB06', 'A spine-tingling story of a cursed village and its dark past.', 9, 2),
    ('BK015', 'The Chronicles of Eldoria: The Lost Kingdom', 35, '978-2-345678-90-7', 'C1', 'G05', 'AU005', 'PB05', 'Epic quest to reclaim a forgotten realm.', 11, 3),
    ('BK016', 'The Arcane Chronicles: Secrets of the Mage Tower', 42, '978-2-345678-90-1', 'C1', 'G05', 'AU005', 'PB05', 'Uncover mysteries in a tower of magic.', 4, 4),
    ('BK017', 'Legends of Alveria: The Prophecys End', 38, '978-3-456789-01-2', 'C1', 'G05', 'AU005', 'PB05', 'Fate unfolds in a realm at war.', 19, 3),
    ('BK018', 'The Dragon Heart Tales of Fire and Fury', 45, '978-4-567890-12-3', 'C1', 'G05', 'AU005', 'PB05', 'Battles rage for a kingdoms destiny.', 5, 2),
    ('BK019', 'Shadows of Elaria: Echoes of Darkness', 36, '978-5-678901-23-4', 'C1', 'G05', 'AU005', 'PB05', 'Darkness threatens to consume a realm.', 13, 3),
    ('BK020', 'Realm of the Crystal Guardians: Rise of the Elementalists', 41, '978-6-789012-34-5', 'C1', 'G05', 'AU005', 'PB05', 'Heroes harness elemental powers to save their world.', 16, 1),
    ('BK021', 'The Hunger Games', 65, '983-0-8315-32-1', 'C1', 'G06', 'AU006', 'PB08', 'Dystopian society pits children in televised death match, sparking retaliation.', 7, 3),
    ('BK022', 'Financial Management: Principles and Applications', 150, '978-1-118-83289-3', 'C3', 'G07', 'AU007', 'PB07', 'Comprehensive guide on financial management principles with practical business applications.', 15, 2);





INSERT INTO Members (MemberID, FirstName, LastName, StateID, ContactNumber, Status, NumberOfOverdues, NumberOfOverduesPaid)
VALUES 
    ('MEM001', 'Divhya', 'Ashley', 'S05', '60134786346', 'Inactive', 0, 0),
    ('MEM002', 'Adam', 'Iqbal', 'S02', '60198366386', 'Active', 1, 1),
    ('MEM003', 'Ng', 'Xing', 'S07', '60158538938', 'Active', 1, 0),
    ('MEM004', 'Vijay', 'Sethupathi', 'S10', '60179369329', 'Active', 0, 0),
    ('MEM005', 'Nor', 'Shamsiah', 'S12', '60167836825', 'Inactive', 0, 0),
    ('MEM006', 'Neha', 'Naidu', 'S15', '60187469376', 'Inactive', 0, 0),
    ('MEM007', 'Areeba', 'Sheikh', 'S06', '60137826728', 'Active', 2, 2),
    ('MEM008', 'Kenji', 'Liew', 'S02', '60174589268', 'Active', 3, 3),
    ('MEM009', 'Raja', 'Nazihah', 'S01', '60106438296', 'Inactive', 0, 0),
    ('MEM010', 'Nithya', 'Greald', 'S05', '60138865293', 'Active', 3, 3),
    ('MEM011', 'Ahmad', 'Hariz', 'S01', '60134658479', 'Active', 0, 0),
    ('MEM012', 'Muhammand', 'Abdullah', 'S12', '60125835409', 'Active', 2, 1),
    ('MEM013', 'Tan', 'Lai Ci', 'S13', '60158630743', 'Inactive', 0, 0),
    ('MEM014', 'Sarvein', 'Raj', 'S04', '60198723986', 'Active', 0, 0),
    ('MEM015', 'Arumugam', 'Shan', 'S11', '60158892532', 'Inactive', 0, 0),
    ('MEM016', 'Alif', 'Fitri', 'S02', '60169873207', 'Active', 2, 2),
    ('MEM017', 'Nurul', 'Zafirah', 'S07', '60168326391', 'Active', 1, 1),
    ('MEM018', 'Shrithar', 'Naiidu', 'S14', '60135925709', 'Inactive', 0, 0),
    ('MEM019', 'Lai', 'Wei Jun', 'S03', '60122200368', 'Active', 1, 0),
    ('MEM020', 'Mei', 'Ching Yong', 'S10', '60145924845', 'Active', 1, 1),
    ('MEM021', 'Arina', 'Akmal', 'S11', '60124592648', 'Active', 3, 2),
    ('MEM022', 'Alieff', 'Zaim', 'S03', '60107486493', 'Inactive', 0, 0),
    ('MEM023', 'Nurul', 'Ameera', 'S02', '60122046200', 'Active', 0, 0),
    ('MEM024', 'Vikram', 'Kumar', 'S14', '60158302882', 'Inactive', 0, 0),
    ('MEM025', 'Kavin', 'Raj', 'S09', '60155999478', 'Active', 4, 2),
    ('MEM026', 'Trisshen', 'Rau', 'S14', '60122364970', 'Active', 2, 0),
    ('MEM027', 'Lim', 'Yik Zhen', 'S02', '60176090023', 'Inactive', 0, 0),
    ('MEM028', 'Alysha', 'Karim', 'S04', '60136590377', 'Active', 2, 1),
    ('MEM029', 'Nur', 'Safura', 'S11', '60197465835', 'Active', 4, 1),
    ('MEM030', 'Rizal', 'Rosmi', 'S01', '60126407593', 'Inactive', 0, 0);




INSERT INTO Loans (LoanID, MemberID, BookID, BorrowDate, ReturnDate)
VALUES 
    ('LOA001', 'MEM002', 'BK001', '2023-02-03', '2023-02-17'),
    ('LOA002', 'MEM003', 'BK002', '2023-04-10', '2023-04-24'),
    ('LOA003', 'MEM007', 'BK003', '2023-06-15', '2023-06-29'),
    ('LOA004', 'MEM007', 'BK004', '2023-08-20', '2023-09-03'),
    ('LOA005', 'MEM008', 'BK005', '2023-10-07', '2023-10-21'),
    ('LOA006', 'MEM008', 'BK006', '2024-03-15', '2024-03-28'),
    ('LOA007', 'MEM008', 'BK007', '2024-06-07', '2024-06-20'),
    ('LOA008', 'MEM010', 'BK008', '2024-05-18', '2024-06-01'),
    ('LOA009', 'MEM010', 'BK009', '2023-03-15', '2023-04-11'),
    ('LOA010', 'MEM010', 'BK010', '2023-05-22', '2023-06-18'),
    ('LOA011', 'MEM012', 'BK011', '2023-08-07', '2023-09-03'),
    ('LOA012', 'MEM012', 'BK012', '2023-10-19', '2023-11-15'),
    ('LOA013', 'MEM016', 'BK013', '2023-12-28', '2024-01-24'),
    ('LOA014', 'MEM016', 'BK014', '2023-02-03', '2023-03-02'),
    ('LOA015', 'MEM017', 'BK015', '2023-05-14', '2023-06-13'),
    ('LOA016', 'MEM019', 'BK016', '2024-02-14', '2024-03-12'),
    ('LOA017', 'MEM020', 'BK017', '2024-04-27', '2024-05-25'),
    ('LOA018', 'MEM021', 'BK018', '2024-07-10', '2024-08-07'),
    ('LOA019', 'MEM021', 'BK019', '2024-09-23', '2024-10-21'),
    ('LOA020', 'MEM021', 'BK020', '2024-12-06', '2025-01-03'),
    ('LOA021', 'MEM025', 'BK021', '2024-01-19', '2024-02-16'),
    ('LOA022', 'MEM025', 'BK001', '2023-03-15', '2023-03-28'),
    ('LOA023', 'MEM025', 'BK002', '2023-06-07', '2023-06-20'),
    ('LOA024', 'MEM025', 'BK004', '2023-09-18', '2023-10-01'),
    ('LOA025', 'MEM026', 'BK005', '2024-03-15', '2024-03-28'),
    ('LOA026', 'MEM026', 'BK006', '2023-03-16', '2024-06-20'),
    ('LOA027', 'MEM028', 'BK007', '2023-03-17', '2024-10-01'),
    ('LOA028', 'MEM028', 'BK011', '2023-03-18', '2023-04-11'),
    ('LOA029', 'MEM029', 'BK013', '2023-03-19', '2023-06-18'),
    ('LOA030', 'MEM029', 'BK015', '2024-03-15', '2024-04-11'),
    ('LOA031', 'MEM029', 'BK016', '2024-05-22', '2024-06-18'),
    ('LOA032', 'MEM029', 'BK019', '2024-08-07', '2024-09-03');




INSERT INTO Fines (FineID, MemberID, LoanID, OverdueDays, TotalFine, Cleared)
VALUES 
    ('F001', 'MEM002', 'LOA001', 2, 1.00, 'Yes'),
    ('F002', 'MEM003', 'LOA002', 1, 0.50, 'No'),
    ('F003', 'MEM007', 'LOA003', 3, 1.50, 'Yes'),
    ('F004', 'MEM007', 'LOA004', 2, 1.00, 'Yes'),
    ('F005', 'MEM008', 'LOA005', 1, 0.50, 'Yes'),
    ('F006', 'MEM008', 'LOA006', 4, 2.00, 'Yes'),
    ('F007', 'MEM008', 'LOA007', 2, 1.00, 'Yes'),
    ('F008', 'MEM010', 'LOA008', 1, 0.50, 'Yes'),
    ('F009', 'MEM010', 'LOA009', 2, 0.60, 'Yes'),
    ('F010', 'MEM010', 'LOA010', 3, 0.90, 'Yes'),
    ('F011', 'MEM012', 'LOA011', 4, 1.20, 'No'),
    ('F012', 'MEM012', 'LOA012', 1, 0.30, 'Yes'),
    ('F013', 'MEM016', 'LOA013', 2, 0.60, 'Yes'),
    ('F014', 'MEM016', 'LOA014', 3, 0.90, 'Yes'),
    ('F015', 'MEM017', 'LOA015', 2, 0.60, 'Yes'),
    ('F016', 'MEM019', 'LOA016', 5, 1.50, 'No'),
    ('F017', 'MEM020', 'LOA017', 1, 0.30, 'Yes'),
    ('F018', 'MEM021', 'LOA018', 2, 0.60, 'Yes'),
    ('F019', 'MEM021', 'LOA019', 1, 0.30, 'Yes'),
    ('F020', 'MEM021', 'LOA020', 4, 1.20, 'No'),
    ('F021', 'MEM025', 'LOA021', 2, 0.60, 'No'),
    ('F022', 'MEM025', 'LOA022', 1, 0.50, 'No'),
    ('F023', 'MEM025', 'LOA023', 3, 1.50, 'Yes'),
    ('F024', 'MEM025', 'LOA024', 2, 1.00, 'Yes'),
    ('F025', 'MEM026', 'LOA025', 2, 1.00, 'No'),
    ('F026', 'MEM026', 'LOA026', 2, 1.00, 'No'),
    ('F027', 'MEM028', 'LOA027', 4, 2.00, 'Yes'),
    ('F028', 'MEM028', 'LOA028', 1, 0.30, 'No'),
    ('F029', 'MEM029', 'LOA029', 2, 0.60, 'Yes'),
    ('F030', 'MEM029', 'LOA030', 3, 0.90, 'No'),
    ('F031', 'MEM029', 'LOA031', 1, 0.30, 'No'),
    ('F032', 'MEM029', 'LOA032', 3, 0.90, 'No');


INSERT INTO Rooms (RoomID, RoomName)
VALUES 
	('R01', 'Room1'),
	('R02', 'Room2'),
	('R03', 'Room3'),
	('R04', 'Room4'),
	('R05', 'Room5'),
	('R06', 'Room6'),
	('R07', 'Room7'),
	('R08', 'Room8'),
	('R09', 'Room9');



INSERT INTO RoomReservations (RoomReservationID, RoomID, MemberID, RoomReservationDate)
VALUES 
    ('RR1', 'R01', 'MEM004', '2023-02-07'),
    ('RR2', 'R02', 'MEM025', '2024-04-15'),
    ('RR3', 'R03', 'MEM014', '2023-06-29'),
    ('RR4', 'R04', 'MEM019', '2023-09-11'),
    ('RR5', 'R05', 'MEM011', '2024-11-22'),
    ('RR6', 'R06', 'MEM007', '2024-01-03'),
    ('RR7', 'R07', 'MEM028', '2023-03-18'),
    ('RR8', 'R08', 'MEM003', '2024-05-26'),
    ('RR9', 'R09', 'MEM021', '2023-08-09');



INSERT INTO BookReservations (ReservationID, BookID, MemberID, ReservationDate)
VALUES 
    ('RSV001', 'BK020', 'MEM002', '2023-01-15'),
    ('RSV002', 'BK019', 'MEM003', '2023-03-03'),
    ('RSV003', 'BK018', 'MEM004', '2023-05-22'),
    ('RSV004', 'BK017', 'MEM007', '2023-07-07'),
    ('RSV005', 'BK016', 'MEM008', '2023-08-19'),
    ('RSV006', 'BK015', 'MEM010', '2023-10-28'),
    ('RSV007', 'BK014', 'MEM011', '2023-11-12'),
    ('RSV008', 'BK013', 'MEM012', '2023-12-25'),
    ('RSV009', 'BK012', 'MEM014', '2023-12-31'),
    ('RSV010', 'BK011', 'MEM016', '2024-01-09'),
    ('RSV011', 'BK010', 'MEM017', '2024-03-17'),
    ('RSV012', 'BK009', 'MEM019', '2024-05-26'),
    ('RSV013', 'BK008', 'MEM020', '2024-07-04'),
    ('RSV014', 'BK007', 'MEM021', '2024-08-21'),
    ('RSV015', 'BK006', 'MEM023', '2024-10-10'),
    ('RSV016', 'BK005', 'MEM025', '2024-11-15'),
    ('RSV017', 'BK004', 'MEM026', '2024-12-22'),
    ('RSV018', 'BK003', 'MEM028', '2023-09-28'),
    ('RSV019', 'BK002', 'MEM029', '2024-12-31');





--1
SELECT Books.Title, Books.BookDescription, Categories.Category, Categories.CategoryDescription
FROM Books 
JOIN Categories  ON Books.CategoryID = Categories.CategoryID
WHERE Books.QuantityOfCopiesAvailable > 0
AND Books.BookID NOT IN (SELECT DISTINCT BookID FROM Loans)
ORDER BY Books.Title ASC;


--2
SELECT Members.FirstName, Members.LastName, Books.Title AS BookName, Loans.BorrowDate
FROM Members 
JOIN Loans  ON Members.MemberID = Loans.MemberID
JOIN Books  ON Loans.BookID = Books.BookID
WHERE Members.Status = 'Active'
AND YEAR(Loans.BorrowDate) = 2023
ORDER BY Loans.BorrowDate ASC;


--3
SELECT Members.FirstName, Members.LastName, Members.ContactNumber, 
       SUM(CASE WHEN Fines.Cleared = 'Yes' THEN 1 ELSE 0 END) AS NumberOfOverduesPaid,
       SUM(Fines.TotalFine) AS TotalDueAmount
FROM Members 
JOIN Fines  ON Members.MemberID = Fines.MemberID
GROUP BY Members.FirstName, Members.LastName, Members.ContactNumber
HAVING SUM(CASE WHEN Fines.Cleared = 'Yes' THEN 1 ELSE 0 END) > 2;



--4
WITH BookLoansCount AS (
    SELECT 
        Books.BookID,
        Books.Title AS MostBorrowedBookName,
        Books.BookDescription AS MostBorrowedBookDescription,
        Books.CategoryID,
        COUNT(Loans.LoanID) AS LoanCount
    FROM 
        Books
        JOIN Loans ON Books.BookID = Loans.BookID
    GROUP BY 
        Books.BookID, Books.Title, Books.BookDescription, Books.CategoryID
),
MaxLoanPerCategory AS (
    SELECT 
        CategoryID,
        MAX(LoanCount) AS MaxLoanCount
    FROM 
        BookLoansCount
    GROUP BY 
        CategoryID
)
SELECT 
    Categories.Category,
    BLC.MostBorrowedBookName,
    BLC.MostBorrowedBookDescription
FROM 
    BookLoansCount BLC
    JOIN MaxLoanPerCategory MLPC ON BLC.CategoryID = MLPC.CategoryID AND BLC.LoanCount = MLPC.MaxLoanCount
    JOIN Categories ON BLC.CategoryID = Categories.CategoryID
WHERE 
    BLC.BookID = (
        SELECT TOP 1 BookID 
        FROM BookLoansCount 
        WHERE CategoryID = BLC.CategoryID 
        ORDER BY LoanCount DESC
    )
ORDER BY 
    Categories.Category DESC;


--5
SELECT TOP 1 Genres.GenreID, Genres.Genre, COUNT(*) AS TotalBooks
FROM Books
JOIN Genres ON Books.GenreID = Genres.GenreID
GROUP BY Genres.GenreID, Genres.Genre
ORDER BY TotalBooks DESC;



--6
SELECT COUNT(*) AS TotalBooksReserved
FROM BookReservations
WHERE YEAR(ReservationDate) = 2023;


--7
SELECT TOP 1 Publishers.Publisher, COUNT(*) AS TotalYellowTagBooks
FROM Books 
JOIN Publishers ON Books.PublisherID = Publishers.PublisherID
JOIN Categories ON Books.CategoryID = Categories.CategoryID
WHERE Categories.Category = 'Yellow'
GROUP BY Publishers.Publisher
ORDER BY COUNT(*) ASC;



--8
SELECT Authors.Author, COUNT(*) AS BookCount
FROM Books 
JOIN Authors ON Books.AuthorID = Authors.AuthorID
GROUP BY Authors.Author
ORDER BY COUNT(*) DESC;


--9
SELECT DISTINCT Members.FirstName, Members.LastName, Members.ContactNumber
FROM Members
JOIN Loans ON Members.MemberID = Loans.MemberID
JOIN Books ON Loans.BookID = Books.BookID
JOIN Genres ON Books.GenreID = Genres.GenreID
WHERE Genres.Genre = 'Fantasy';


--10
SELECT Books.Title, Books.BookDescription, Publishers.Publisher, Publishers.PublisherAddress
FROM Books 
JOIN Publishers ON Books.PublisherID = Publishers.PublisherID
WHERE Books.BookCost > 50;


