set @billno='rm_billingmembers';
set @tenant_id='1137687541223680';	
 
SELECT id into @billid from bill_base where cBillNo=@billno and tenant_id=@tenant_id;

SELECT * from bill_base where id=@billid;

SELECT * from billentity_base where iBillId=@billid;

SELECT * from billtemplate_base where iBillId=@billid;

SELECT * from billtplgroup_base where iBillId=@billid;

SELECT * from billitem_base where iBillId=@billid and tenant_id=@tenant_id;

SELECT * from pub_makebillrule where iBillId=@billid;

SELECT a.* from pub_makebillrule_detail a INNER JOIN pub_makebillrule b on a.makebill_id=b.makebill_id where b.iBillId=@billid;

SELECT * from bill_toolbar where billnumber=@billno and tenant_id=@tenant_id;

SELECT * from bill_toolbaritem where billnumber=@billno and tenant_id=@tenant_id;

SELECT * from bill_command where billnumber=@billno and tenant_id=@tenant_id;