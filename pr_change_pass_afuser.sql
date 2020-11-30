--fopks_api.pr_change_pass_afuser

PROCEDURE pr_change_pass_afuser(   pv_strCUSTODYCD IN VARCHAR2,
                             pv_strACCTNO IN VARCHAR2,
                             pv_strOLDPIN IN VARCHAR2,
                             pv_strNEWPIN IN VARCHAR2,
                             p_err_code      in out varchar2,
                             p_err_param     in out varchar2
                             )
IS
          l_count NUMBER;
          l_status varchar2(1);
          l_autoid number;
          l_record_key varchar(20);
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
    
    select count(1) into l_count from afuser where custodycd = pv_strCUSTODYCD and afacctno = pv_strACCTNO and PIN  = genencryptpassword(pv_strOLDPIN);
    if l_count = 0 THEN 
      p_err_code := C_FO_AFUSER_PIN_INVALID;
      raise errnums.E_BIZ_RULE_INVALID;
    else
      SELECT autoid into l_autoid from AFUSER WHERE custodycd = pv_strCUSTODYCD and afacctno = pv_strACCTNO;
      l_record_key := 'AUTOID = ''' || l_autoid || '''';
      UPDATE AFUSER SET PIN = genencryptpassword(pv_strNEWPIN) WHERE custodycd = pv_strCUSTODYCD and afacctno = pv_strACCTNO;
      
      --INSERT maintain_log
      INSERT INTO MAINTAIN_LOG(TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, COLUMN_NAME, FROM_VALUE, TO_VALUE, MOD_NUM, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, RECORD_COLUMN, RECORD_COLUMN_KEY)
      VALUES('AFUSER', l_record_key, '0000', getcurrdate, 'N', 'PIN', '***','***', 0, 'EDIT', null, null, TO_CHAR(SYSDATE, 'HH24:MI:SS'), 'AUTOID', l_autoid);
      
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
