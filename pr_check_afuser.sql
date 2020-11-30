-- fopks_api.pr_check_afuser

--2020.11.1.4 verify pin màn hình 020032
PROCEDURE pr_check_afuser(   pv_strCUSTODYCD IN VARCHAR2,
                             pv_strACCTNO IN VARCHAR2,
                             pv_strPIN IN VARCHAR2,
                             p_err_code      in out varchar2,
                             p_err_param     in out varchar2
                             )
IS
          l_count NUMBER;
          l_status varchar2(1);
BEGIN
    
    select count(1) into l_count from afuser where custodycd = pv_strCUSTODYCD and afacctno = pv_strACCTNO;
    
    if l_count = 0 then
      p_err_code := C_FO_AFUSER_DOES_NOT_EXISTED; -- tiểu khoản đăng ký mã truy cập không tồn tại
      raise errnums.E_BIZ_RULE_INVALID;
    end if;
   
    select u.status into l_status from afuser u where u.custodycd = pv_strCUSTODYCD and u.afacctno = pv_strACCTNO;
    if nvl(l_status,'X') <> 'A' then
       p_err_code := C_FO_AFUSER_STATUS_INVALID; -- trạng thái đăng ký mã truy cập đang đóng
       raise errnums.E_BIZ_RULE_INVALID;
    end if;
    
    select count(1) into l_count from afuser where custodycd = pv_strCUSTODYCD and afacctno = pv_strACCTNO and PIN  = pv_strPIN;
    if l_count = 0 THEN 
      p_err_code := C_FO_AFUSER_PIN_INVALID;
      raise errnums.E_BIZ_RULE_INVALID;
    else
      p_err_code  := systemnums.C_SUCCESS;
      p_err_param := 'SUCCESS';
    end if;
EXCEPTION
  WHEN errnums.E_BIZ_RULE_INVALID THEN
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code)
      loop
        p_err_param := i.errdesc;
      end loop;
END;
--end 2020.11.1.4

---
select errdesc, en_errdesc
                  from deferror
                 where errnum = '-107'
select * from deferror where errnum like '-11%'order by errnum for update;

select * from deferror where errnum like '-110';



insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-111, '[H111]: Không tồn tại đang ký mã truy cập cho tiểu khoản! ', '[H111]: Access code for sub-account not registered!', 'HT', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-112, '[H112]: Trạng thái đang ký mã truy cập đang đóng!', '[H112]: Access code''s registration invalid', 'HT', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-113, '[H113]: Mã truy cập không đúng!', '[H113]: Access  code invalid!', 'HT', null);

prompt Done.







