-- SECALLOWT0 AFUSER 037C000256
select * from cmdmenu where cmdid in ('020031','020032') for update; --Quản lý Mã truy cập của tiểu khoản Management of Sub account's access code
--
select * from apprvrqd;
--8bbab69505da0b432e180a3cf6e14466
SELECT * FROM AFUSER for update;
SELECT U.AUTOID, U.CUSTODYCD, U.AFACCTNO, U.CUSTNAME, U.CREATEDDT, U.STATUS STATUSCD, A.CDCONTENT STATUS,
       U.DESCRIPTION, U.PIN
FROM AFUSER U, ALLCODE A
WHERE A.CDNAME = 'STATUS' AND A.CDTYPE = 'CF' AND A.CDVAL = U.STATUS;
--
select * from search where searchcode like'%AFUSER%' for update;

select * from searchfld where searchcode like'AFUSER' for update;
--
select * from objmaster where objname like '%SECALLOWT0%'for update;
select * from objmaster where objname like '%CF.AFUSER%'for update;
--
select * from grmaster where objname like '%SECALLOWT0%'for update;
select * from grmaster where objname like '%CF.AFUSER%'for update;
--
select * from fldmaster where objname like '%SECALLOWT0%' for update;
select * from fldval where objname like '%SECALLOWT0%' for update;

select * from fldmaster where objname like '%CF.AFUSER%' for update;
select * from fldval where objname like '%CF.AFUSER%' for update;

-- Mã truy cập ít nhất một kí tự chữ in hoa, in thường và số. Độ dài từ 6 đến 20 kí tự 
-- Access codes are at least one uppercase, lowercase and numeric character. Length from 6 to 20 characters
select * from cfmast where custodycd = '037C000256';
select * from afmast where custid = '0001001455' for update;

select status from afmast group by status;
--


insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200178, '[-200178]: Mã truy cập ít nhất một kí tự chữ in hoa, in thường và số. Độ dài từ 6 đến 20 kí tự', '[-200178]: Access codes are at least one uppercase, lowercase and numeric character. Length from 6 to 20 characters', 'SA', 0);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200177, '[-200177]: Tiểu khoản đã đăng ký Mã số truy cập', '[-200177]: Sub account have already registered access code', 'SA', 0);

select GENENCRYPTPASSWORD ('Phamtoan07101234123') from dual; -- 6d80f22a37abdce8804982e1e0bd58ce 051e2d38a5522d23a9bc16b317774c3e
select * from deferror where errnum like '-2001%' order by errnum for update;
