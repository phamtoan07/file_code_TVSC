drop table afuser;
create table afuser
(
 autoid number,
 custodycd VARCHAR2(20),
 custname  VARCHAR2(1000),
 afacctno  VARCHAR2(20),
 PIN      VARCHAR2(100),
 CREATEDDT DATE default sysdate,
 CREATEDBY varchar2(10),
 status    varchar2(1) default 'A',
 PSTATUS   VARCHAR2(2000),
 LASTCHANGE DATE default sysdate,
 DESCRIPTION      VARCHAR2(1000)
);
create sequence seq_afuser;
