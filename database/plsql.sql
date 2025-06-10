-- #############################
-- Reset database data
-- #############################
DROP PROCEDURE IF EXISTS sp_ResetDatabase;

DELIMITER //
CREATE PROCEDURE sp_ResetDatabase()

BEGIN
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;

-- -----------------------------------------------------
-- 
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cs340_flennikj` DEFAULT CHARACTER SET utf8 ;
-- USE `cs340_flennikj` ;

-- -----------------------------------------------------
-- Table `cs340_flennikj`.`Customers`
-- -----------------------------------------------------

CREATE OR REPLACE TABLE `cs340_flennikj`.`Customers` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phoneNumber` BIGINT(10) NULL DEFAULT 0000000000,
  PRIMARY KEY (`customerID`));

--
-- Dumping data for table `cs340_flennikj`.`Customers`
--

INSERT INTO `Customers` VALUES (
    1,
    "John",
    "Cena",
    "ucantCme@gmail.com",
    1235551234
),
(
    2,
    "Shakira",
    "Shakira",
    "hipsXlie@wyclef.jean",
    8005554321
),
(
    3,
    "Tom",
    "Servo",
    "SoL@gizmonic.edu",
    1234567890
);


-- -----------------------------------------------------
-- Table `cs340_flennikj`.`Employees`
-- -----------------------------------------------------

CREATE OR REPLACE TABLE `cs340_flennikj`.`Employees` (
  `employeeID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phoneNumber` BIGINT(10) NOT NULL,
  PRIMARY KEY (`employeeID`),
  UNIQUE INDEX `employeeID_UNIQUE` (`employeeID` ASC) VISIBLE);

--
-- Dumping data for table `cs340_flennikj`.`Employees`
--

INSERT INTO `Employees` VALUES (
    1,
    "Randy",
    "Savage",
    "Oyeahhh@slimjim.com",
    1231231234
),
(
    2,
    "Kim",
    "Gordon",
    "koolthing@teenageriot.org",
    8005674321
),
(
    3,
    "Janet",
    "Weiss",
    "denton@Ohio.gov",
    9012345678
);

-- -----------------------------------------------------
-- Table `cs340_flennikj`.`Orders`
-- -----------------------------------------------------

CREATE OR REPLACE TABLE `cs340_flennikj`.`Orders` (
  `orderID` INT NOT NULL AUTO_INCREMENT,
  `customerID` INT NOT NULL,
  `employeeID` INT NOT NULL,
  `orderDate` DATETIME NOT NULL,
  PRIMARY KEY (`orderID`),
  UNIQUE INDEX `orderID_UNIQUE` (`orderID` ASC) VISIBLE,
  INDEX `employeeID_idx` (`employeeID` ASC) VISIBLE,
  CONSTRAINT `customerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `cs340_flennikj`.`Customers` (`customerID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `employeeID`
    FOREIGN KEY (`employeeID`)
    REFERENCES `cs340_flennikj`.`Employees` (`employeeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

--
-- Dumping data for table `cs340_flennikj`.`Orders`
--

INSERT INTO `Orders` VALUES (
    1,
    1,
    3,
    "2024-01-01"
),
(
    2,
    2,
    2,
    "2025-02-28"
),
(
    3,
    3,
    1,
    "2025-05-01"
);


-- -----------------------------------------------------
-- Table `cs340_flennikj`.`Products`
-- -----------------------------------------------------

CREATE OR REPLACE TABLE `cs340_flennikj`.`Products` (
  `productID` INT NOT NULL AUTO_INCREMENT,
  `productName` VARCHAR(255) NOT NULL,
  `productCategory` VARCHAR(45) NOT NULL,
  `productPrice` DECIMAL(8,2) NOT NULL,
  `productStock` INT NOT NULL,
  `isActive` TINYINT NOT NULL,
  PRIMARY KEY (`productID`),
  UNIQUE INDEX `productID_UNIQUE` (`productID` ASC) VISIBLE);

--
-- Dumping data for table `cs340_flennikj`.`Products`
--

INSERT INTO `Products` VALUES (
    1,
    "Cherry Red ‘64 Strat (w/ a Whammy Bar)",
    "Guitar",
    1200.00,
    1,
    1
),
(
    2,
    "Fiddle Made of Gold",
    "Orchestral",
    9999.99,
    5,
    1
),
(
    3,
    "‘68 Gibson SG (in mint Condish)",
    "Guitar",
    2200.00,
    13,
    1
),
(
    4,
    "Pick of Destiny",
    "Occult",
    666.00,
    0,
    0
);

-- -----------------------------------------------------
-- Table `cs340_flennikj`.`OrderDetails`
-- -----------------------------------------------------

CREATE OR REPLACE TABLE `cs340_flennikj`.`OrderDetails` (
  `orderDetailsID` INT NOT NULL AUTO_INCREMENT,
  `orderID` INT NOT NULL,
  `productID` INT NOT NULL,
  `orderQuantity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`orderDetailsID`),
  CONSTRAINT `orderID`
    FOREIGN KEY (`orderID`)
    REFERENCES `cs340_flennikj`.`Orders` (`orderID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `productID`
    FOREIGN KEY (`productID`)
    REFERENCES `cs340_flennikj`.`Products` (`productID`)
    ON DELETE NO ACTION
    );

--
-- Dumping data for table `cs340_flennikj`.`OrderDetails`
--

INSERT INTO `OrderDetails` VALUES (
	1,
    1,
    1,
    1
),
(
	2,
    2,
    2,
    2
),
(
	3,
    3,
    3,
    3
),
(	4,
    1,
    3,
    1
);


SET FOREIGN_KEY_CHECKS=1;
COMMIT;
END //
DELIMITER ;


-- #############################
-- DELETE Customers
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteCustomer;

DELIMITER //
CREATE PROCEDURE sp_DeleteCustomer(IN p_customerID INT)
BEGIN

    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on error
        ROLLBACK;
        -- Send error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;

        DELETE FROM Orders WHERE customerID = p_customerID;
        DELETE FROM Customers WHERE customerID = p_customerID;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Customers for customerID: ', p_customerID);
            -- Trigger error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;
