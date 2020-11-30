--- api pr_GETCONTRACTLIST
PROCEDURE pr_GETCONTRACTLIST(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                             pv_strCUSTID IN VARCHAR2,
                             pv_strCUSTODYCD IN VARCHAR2,
                             pv_strVIA IN VARCHAR2 DEFAULT 'A')
IS
          l_count NUMBER;
          l_strVia varchar2(5);
BEGIN
 SELECT count (1) into l_count
    from otright o, cfmast cf
    where deltd <> 'Y'
       AND getcurrdate <= EXPDATE and o.valdate <= getcurrdate
       and o.cfcustid = o.authcustid
       and o.authcustid = cf.custid
       and cf.custid = pv_strCUSTID
       and o.via = pv_strVIA;

    if(l_count > 0) then l_strVia := pv_strVIA;
    else l_strVia := 'A';
     end if;

  SELECT COUNT(*) INTO l_count
  FROM Userlogin
  WHERE username = pv_strCUSTODYCD AND status <> 'E';
  IF l_count <> 0 THEN
    OPEN p_REFCURSOR FOR
     SELECT DECODE (AFT.PRODUCTTYPE,'NN',3,'NM',2,'QM',1) OWNER,AF.ACCTNO,CF.Fax FAX1,CF.Email,CF.CUSTODYCD,AF.CUSTID,CF.FULLNAME,CF.FULLNAME SHORTNAME,'YYYYYYYYYY' LINKAUTH,AF.BANKACCTNO,
              AF.BANKNAME,(case when ci.corebank = 'Y' then ci.corebank else af.alternateacct end) COREBANK,AF.STATUS,AL.CDCONTENT TYPENAME, AFT.AFTYPE,AL.EN_CDCONTENT EN_TYPENAME,
              (CASE WHEN R.EXPDATE < TO_DATE(getcurrdate, 'DD/MM/RRRR') THEN 'Y' ELSE 'N' END) EXPIRED,CF.TRADEONLINE,AF.AUTOADV,AFT.Mnemonic MNEMONIC ,AFT.Mnemonic EN_MNEMONIC,
              (CASE WHEN NVL(U.STATUS,'X') = 'A' THEN Y ELSE 'N' END)  ISAFUSER 
                FROM otright R, AFMAST AF,CFMAST CF,CIMAST CI, AFTYPE AFT, ALLCODE AL, AFUSER U
                WHERE AF.CUSTID=CF.CUSTID
                AND AF.ACCTNO=CI.AFACCTNO
                AND AF.ACTYPE=AFT.ACTYPE
                --AND R.AFACCTNO = AF.ACCTNO
                AND R.CFCUSTID=AF.custid
                AND R.AUTHCUSTID = CF.CUSTID
                AND R.DELTD = 'N'
                AND NVL(R.CHSTATUS,'C') <> 'A'
                AND AF.CUSTID=pv_strCUSTID
                AND AF.ISFIXACCOUNT='N'
                and al.cdtype='CF'
                and al.cdname='PRODUCTTYPE'
                and al.cdval=AFT.PRODUCTTYPE
                and cf.custodycd = pv_strCUSTODYCD
                and af.status <> 'C'
                and R.VIA = l_strVia
                and U.AFACCTNO(+) = AF.ACCTNO 
                and u.custodycd(+) = pv_strCUSTODYCD;
                --AND AF.TRADEONLINE = 'Y'
                --AND TO_DATE(:TXDATE, 'DD/MM/RRRR') <= R.EXPDATE
        UNION ALL
         SELECT 0 OWNER,AF.ACCTNO,CF.Fax FAX1,CF.Email,CF.CUSTODYCD,CF.CUSTID,CF.FULLNAME,CF.FULLNAME SHORTNAME,'NNNNNNNNNN' LINKAUTH,AF.BANKACCTNO,
                AF.BANKNAME,(case when ci.corebank = 'Y' then ci.corebank else af.alternateacct end) COREBANK,AF.STATUS, AL.CDCONTENT TYPENAME,AFT.AFTYPE,AL.EN_CDCONTENT EN_TYPENAME,
                (CASE WHEN R.EXPDATE < TO_DATE(getcurrdate, 'DD/MM/RRRR') THEN 'Y' ELSE 'N' END) EXPIRED,CF.TRADEONLINE,AF.AUTOADV,AFT.Mnemonic MNEMONIC ,AFT.Mnemonic EN_MNEMONIC,
                (CASE WHEN NVL(U.STATUS,'X') = 'A' THEN Y ELSE 'N' END)  ISAFUSER 
                FROM otright R, AFMAST AF, CFMAST CF, CIMAST CI, AFTYPE AFT, ALLCODE AL, AFUSER U
                WHERE AF.CUSTID=CF.CUSTID
                AND AF.ACCTNO=CI.AFACCTNO
                AND AF.ACTYPE=AFT.ACTYPE
                --AND R.AFACCTNO = AF.ACCTNO
                AND R.CFCUSTID=AF.custid
                AND R.AUTHCUSTID <> CF.CUSTID
                AND R.DELTD = 'N'
                AND NVL(R.CHSTATUS,'C') <> 'A'
                AND R.AUTHCUSTID = pv_strCUSTID
                AND AF.ISFIXACCOUNT='N'
                and al.cdtype='CF'
                and al.cdname='PRODUCTTYPE'
                and al.cdval=AFT.PRODUCTTYPE
                and cf.custodycd = pv_strCUSTODYCD
                and af.status <> 'C'
                and R.VIA = l_strVia
                and U.AFACCTNO(+) = AF.ACCTNO 
                and u.custodycd(+) = pv_strCUSTODYCD;
                --AND AF.TRADEONLINE = 'Y'
                --AND TO_DATE(:TXDATE, 'DD/MM/RRRR') <= R.EXPDATE
          ORDER BY OWNER DESC;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
