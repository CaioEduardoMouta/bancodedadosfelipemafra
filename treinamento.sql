CREATE TABLESPACE RECURSOS_HUMANOS 
DATAFILE 'C:/DATA/RH_01.DBF'
SIZE 100M AUTOEXTEND
ON NEXT 100M
MAXSIZE 4096M;

ALTER TABLESPACE RECURSOS_HUMANOS 
ADD DATAFILE 'C:/DATA/RH_02.DBF'
SIZE 200M AUTOEXTEND
ON NEXT 200M
MAXSIZE 4096M;

SELECT TABLESPACE_NAME, FILE_NAME FROM DBA_DATA_FILES;

-- SEQUENCES 

CREATE SEQUENCE SEQ_GERAL
START WITH 100
INCREMENT BY 10;

-- CRIANDO UMA TABELA NA TABLESPACE

CREATE TABLE FUNCIONARIOS(
    IDFUNCIONARIO INT PRIMARY KEY,
    NOME VARCHAR2(30)
)TABLESPACE RECURSOS_HUMANOS;

INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL,'JOAO');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'CLARA');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'LILIAN');

SELECT * FROM FUNCIONARIOS;

-- CRIANDO TABLESPACE DE MARKETING

CREATE TABLESPACE MARKETING 
DATAFILE 'C:/DATA/MKT_01.DBF'
SIZE 100M AUTOEXTEND
ON NEXT 100M
MAXSIZE 4096M;

CREATE TABLE CAMPANHAS(
    IDCAMPANHA INT PRIMARY KEY,
    NOME VARCHAR2(30)
)TABLESPACE MARKETING;

INSERT INTO CAMPANHAS VALUES(SEQ_GERAL.NEXTVAL, 'PRIMAVERA');
INSERT INTO CAMPANHAS VALUES(SEQ_GERAL.NEXTVAL, 'VER?O');
INSERT INTO CAMPANHAS VALUES(SEQ_GERAL.NEXTVAL, 'INVERNO');

SELECT * FROM CAMPANHAS;

-- COLOCANDO A TS OFFLINE 

ALTER TABLESPACE RECURSOS_HUMANOS OFFLINE;

--APONTAR O DICIONARIO DE DADOS 

ALTER TABLESPACE RECURSOS_HUMANOS
RENAME DATAFILE 'C:/DATA/RH_01.DBF' TO 'C:/PRODUCAO/RH_01.DBF';

ALTER TABLESPACE RECURSOS_HUMANOS
RENAME DATAFILE 'C:/DATA/RH_02.DBF' TO 'C:/PRODUCAO/RH_02.DBF';

-- TORNANDO A TABLESPACE ONLINE 

ALTER TABLESPACE RECURSOS_HUMANOS ONLINE

SELECT * FROM FUNCIONARIOS;

SELECT * FROM CAMPANHAS;

DROP TABLE ALUNO;

CREATE TABLE ALUNO (
	IDALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);

CREATE SEQUENCE SEQ_EXEMPLO;

INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'JOAO','JOAO@GMAIL.COM',1000.00);
INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'CLARA','CLARA@GMAIL.COM',2000.00);
INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'CELIA','CELIA@GMAIL.COM',3000.00);

CREATE TABLE ALUNO2 (
	IDALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);

INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL,'JOAO','JOAO@GMAIL.COM',1000.00);
INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL,'CLARA','CLARA@GMAIL.COM',2000.00);
INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL,'CELIA','CELIA@GMAIL.COM',3000.00);

SELECT * FROM ALUNO2;

/* ROWID ROWNUM */

SELECT ROWID, IDALUNO, NOME , EMAIL FROM ALUNO;

SELECT ROWID,ROWNUM,IDALUNO, NOME , EMAIL FROM ALUNO;

SELECT NOME, EMAIL FROM ALUNO WHERE ROWNUM <= 2;

/* PROCEDURE */

CREATE OR REPLACE PROCEDURE BONUS1(
        P_IDALUNO ALUNO.IDALUNO%TYPE, 
        P_PERCENT NUMBER)
AS
    BEGIN 
        UPDATE ALUNO SET SALARIO = SALARIO + (SALARIO * (P_PERCENT /100))
        WHERE P_IDALUNO = P_IDALUNO;
    
    END;
    /
SELECT * FROM ALUNO;

CALL BONUS (2,10);

/* TRIGGERS DEVEM TER O TAMANHO M?XIMO DE 32K N?O EXECUTAM
N?O EXECUTAM COMANDOS DE DTL - COMMIT ,ROLLBACK E SAVEPOINTS
*/

/* VALIDA??O */

CREATE OR REPLACE TRIGGER CHECK_SALARIO
BEFORE INSERT OR UPDATE ON ALUNO 
FOR EACH ROW
BEGIN 
    IF :NEW.SALARIO > 2000 THEN
        RAISE_APLICATION_ERROR(-20000, 'VALOR INCORRETO')
    END IF;
END;
/