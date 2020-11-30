﻿--- So lenh
procedure pr_GETNORMALACTIVEORDER
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd  IN  varchar2,
    p_txdate  IN  varchar2
    )
IS

begin
    plog.setbeginsection(pkgctx, 'pr_GETNORMALACTIVEORDER');

        Open p_refcursor for

            SELECT EXECTYPE, DECODE(MATCHTYPEVALUE,'N',EXECTYPE,'P',MATCHTYPEVALUE||EXECTYPE) MATCHTYPE, PRICETYPE, CUSTODYCD, AFACCTNO, AL.CDCONTENT TYPENAME, SYMBOL, ORDERQTTY, ROUND(QUOTEPRICE*1000,15) QUOTEPRICE,
             CASE WHEN EXECQTTY > 0 AND CANCELQTTY = 0 AND ADJUSTQTTY = 0 THEN ORSTATUS || ' ' || EXECQTTY || '/' || ORDERQTTY
                  WHEN CANCELQTTY > 0 AND ADJUSTQTTY=0 THEN ORSTATUS || ' ' || CANCELQTTY || '/' || ORDERQTTY
                  WHEN ADJUSTQTTY > 0 THEN ORSTATUS || ' ' || ADJUSTQTTY || '/' || ORDERQTTY ELSE ORSTATUS END STATUS,
            CASE WHEN EXECQTTY > 0 AND CANCELQTTY = 0 AND ADJUSTQTTY = 0 THEN EN_ORSTATUS || ' ' || EXECQTTY || '/' || ORDERQTTY
                  WHEN CANCELQTTY > 0 AND ADJUSTQTTY=0 THEN EN_ORSTATUS || ' ' || CANCELQTTY || '/' || ORDERQTTY
                  WHEN ADJUSTQTTY > 0 THEN EN_ORSTATUS || ' ' || ADJUSTQTTY || '/' || ORDERQTTY ELSE EN_ORSTATUS END EN_STATUS,
             ORDERID, DECODE(HOSESESSION, 'O', 'Liên tục', 'A', 'Định kỳ', 'P', 'Định kỳ') HOSESESSION,
             SDTIME LASTCHANGE, REMAINQTTY, CANCELQTTY, ADJUSTQTTY, TRADEPLACE, DESC_EXECTYPE,
             ISCANCEL, ISADMEND, ISDISPOSAL, FOACCTNO, TO_CHAR(ODTIMESTAMP,'RRRR/MM/DD hh24:mi:ss.ff9') ODTIMESTAMP, ORSTATUSVALUE,
                 ROUND(NVL(LIMITPRICE*1000,0),15) LIMITPRICE, ROUND(NVL(QUOTEQTTY,0),15) QUOTEQTTY, CONFIRMED, ROUND(EXECQTTY,15) EXECQTTY,ROUND(EXECAMT,15) EXECAMT,
             ORSTATUS,ROUND( CASE WHEN EXECQTTY > 0 THEN EXECAMT/EXECQTTY ELSE 0 END,15) EXECPRICE,
             C.TXTIME,C.USERNAME,C.TXDATE,C.VIA,FEEDBACKMSG, C.TIMETYPE, C.TIMETYPEVALUE, GREATEST(REMAINQTTY*ROUND(QUOTEPRICE*1000,15),0)  REMAINAMT
        FROM BUF_OD_ACCOUNT C, AFMAST AF , AFTYPE AFT , ALLCODE AL
        WHERE C.CUSTODYCD in ( SELECT CF2.CUSTODYCD FROM otrightdtl OT, CFMAST CF, CFMAST CF2 WHERE ot.OTMNCODE = 'ORDINPUT' AND ot.DELTD <> 'Y'
                                AND SUBSTR(ot.otright,1,4) = 'YYYY' AND ot.AUTHCUSTID =CF.CUSTID AND CF.CUSTODYCD = p_custodycd
                                AND OT.CFCUSTID = CF2.custid
                              )
        AND C.TXDATE=TO_DATE(p_txdate,'DD/MM/RRRR')
        AND C.AFACCTNO = AF.ACCTNO AND AF.ACTYPE = AFT.ACTYPE --TT134
        AND AL.CDTYPE ='CF'
                and AL.CDNAME ='PRODUCTTYPE'
                and AL.CDVAL =AFT.PRODUCTTYPE --TT134
        --AND REMAINQTTY>0
        AND ((C.TIMETYPEVALUE='T' AND C.ORSTATUSVALUE <> '10') -- Lenh binh thuong, bao gom ca lenh goc va lenh sua
        OR (C.TIMETYPEVALUE='G' AND C.ORSTATUSVALUE NOT IN ('5', 'P', '6', 'W', 'R')) --Het hieu luc, tu choi, R:lenh dieu kien chua active, bi huy
        )
        ORDER BY ORDERID DESC;


    plog.setendsection(pkgctx, 'pr_GETNORMALACTIVEORDER');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_GETNORMALACTIVEORDER');
end pr_GETNORMALACTIVEORDER;