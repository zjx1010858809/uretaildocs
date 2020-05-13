##非0租户卡片
##部分单据过滤基础表与过滤方案的编号与billnum不一致，单独处理
##风险提示，请执行后自行检查是否结果执行是否正确
set @billno = 'rm_billing_vipPoint';

set @tplmode=0;##部分单模版mode用2，要手工调整，为了处理默认模版的更新
delete billentity_base from billentity_base inner join bill_base on billentity_base.iBillId=bill_base.id where bill_base.cBillNo=@billno and bill_base.tenant_id<>0; 
delete billtemplate_base from billtemplate_base inner join bill_base on billtemplate_base.iBillId=bill_base.id where bill_base.cBillNo=@billno and bill_base.tenant_id<>0; 
delete billtplgroup_base from billtplgroup_base inner join bill_base on billtplgroup_base.iBillId=bill_base.id where bill_base.cBillNo=@billno and bill_base.tenant_id<>0;
delete billitem_base from billitem_base inner JOIN bill_base on billitem_base.iBillId=bill_base.id where bill_base.cBillNo=@billno and bill_base.tenant_id<>0;
delete from bill_base where cBillNo=@billno and tenant_id<>0 ;


delete from bill_toolbar where billnumber=@billno and tenant_id<>0 ;
delete from bill_toolbaritem where billnumber=@billno and tenant_id<>0 ;
delete from bill_command where billnumber=@billno and tenant_id<>0 ;

insert into bill_base(`sysid`,`cBillNo`,`cName`,`cCardKey`,`cSubId`,`iDefTplId`,`iDefPrnTplId`,`iOrder`,`bAllowMultiTpl`,`cDefWhere`,`isDeleted`,`bPrintLimited`,`iSystem`,`cAuthId`,`cBillType`,`cBeanId`,`cFilterId`,`bRowAuthControl`,`bColumnAuthControl`,`bRowAuthObject`,`bColumnAuthControlled`,`bRowAuthControlled`,`cPersonDataSource`,`cCarry`,`authGroupKey`,`datasourcetype`,`datasourcesql`,`batchoperate`,`authType`,`tenant_id`,`pkField`,`parentField`) 
select bill_base.id,`cBillNo`,`cName`,`cCardKey`,`cSubId`,`iDefTplId`,`iDefPrnTplId`,`iOrder`,`bAllowMultiTpl`,`cDefWhere`,`isDeleted`,`bPrintLimited`,`iSystem`,`cAuthId`,`cBillType`,`cBeanId`,`cFilterId`,`bRowAuthControl`,`bColumnAuthControl`,`bRowAuthObject`,`bColumnAuthControlled`,`bRowAuthControlled`,`cPersonDataSource`,`cCarry`,`authGroupKey`,`datasourcetype`,`datasourcesql`,`batchoperate`,`authType`,tenant.id,pkField,parentField
from bill_base 
left join tenant on 1=1 and tenant.id<>0
where cBillNo=@billno and tenant_id=0;

insert into billentity_base(`sysid`,`iBillId`,`cCode`,`cName`,`cSubId`,`iOrder`,`isDeleted`,`cDataSourceName`,`cPrimaryKey`,`iSystem`,`bMain`,`cForeignKey`,`cParentCode`,`childrenField`,`cModelType`,`bIsNull`,`tenant_id`,`isprint`,`queryJoin`, `printKey`,`isTplExport`) 
select billentity_base.id,bill_base.id,`cCode`,billentity_base.cName,billentity_base.cSubId,billentity_base.iOrder,billentity_base.isDeleted,`cDataSourceName`,`cPrimaryKey`,billentity_base.iSystem,`bMain`,`cForeignKey`,`cParentCode`,`childrenField`,`cModelType`,`bIsNull`,tenant.id,isprint,queryJoin, printKey,isTplExport
from billentity_base 
left join tenant on 1=1 
left join bill_base on bill_base.tenant_id=tenant.id 
where bill_base.cBillNo=@billno and bill_base.tenant_id<>0 
and billentity_base.iBillId in (select id from bill_base where cBillNo=@billno and tenant_id=0);

insert into billtemplate_base(`sysid`,`iBillId`,`cName`,`iOrder`,`iTplMode`,`iWidth`,`isDeleted`,`cPrintSetting`,`cPageHeader`,`cPageFooter`,`cTitleHeight`,`iPrintTotal`,`iFixedCols`,`cMemo`,`cTitle`,`iGridStyle`,`cRowLayout`,`cTitleStyle`,`cTotalColor`,`cAmongColor`,`cFixedColor`,`tenant_id`,`templateType`) 
select billtemplate_base.id,bill_base.id,billtemplate_base.cName,billtemplate_base.iOrder,`iTplMode`,`iWidth`,billtemplate_base.isDeleted,`cPrintSetting`,`cPageHeader`,`cPageFooter`,`cTitleHeight`,`iPrintTotal`,`iFixedCols`,`cMemo`,`cTitle`,`iGridStyle`,`cRowLayout`,`cTitleStyle`,`cTotalColor`,`cAmongColor`,`cFixedColor`,tenant.id,`templateType`
from billtemplate_base 
left join tenant on 1=1 
left join bill_base on bill_base.tenant_id=tenant.id 
where bill_base.cBillNo=@billno and bill_base.tenant_id<>0 
and billtemplate_base.iBillId in (select id from bill_base where cBillNo=@billno and tenant_id=0);

insert into billtplgroup_base(`sysid`,`iBillId`,`iBillEntityId`,`iTplId`,`cCode`,`cName`,`cSubId`,`iOrder`,`cDataSourceName`,`cPrimaryKey`,`isDeleted`,`iSystem`,`bMain`,`cForeignKey`,`cParentDataSource`,`cType`,`iParentID`,`cAlign`,`iCols`,`cStyle`,`cImage`,`tenant_id`) 
select billtplgroup_base.id,bill.iBillId,bill.iBillEntityId,bill.iTplId,billtplgroup_base.cCode,billtplgroup_base.cName,billtplgroup_base.cSubId,billtplgroup_base.iOrder,billtplgroup_base.cDataSourceName,billtplgroup_base.cPrimaryKey,billtplgroup_base.isDeleted,billtplgroup_base.iSystem,billtplgroup_base.bMain,billtplgroup_base.cForeignKey,billtplgroup_base.cParentDataSource,`cType`,`iParentID`,`cAlign`,`iCols`,`cStyle`,`cImage`,tenant.id
from billtplgroup_base
left join tenant on 1=1 
left join bill_base on billtplgroup_base.iBillId=bill_base.id and billtplgroup_base.tenant_id=bill_base.tenant_id
left join billentity_base on billentity_base.iBillId=bill_base.id and billentity_base.tenant_id=bill_base.tenant_id and billtplgroup_base.iBillEntityId=billentity_base.id
left join billtemplate_base on billtemplate_base.iBillId=bill_base.id and billtemplate_base.tenant_id=bill_base.tenant_id and billtemplate_base.id= billtplgroup_base.iTplId 
left join (select bill_base.id as iBillId,billentity_base.id as iBillEntityId ,billtemplate_base.id as iTplId,bill_base.tenant_id,
					billentity_base.cCode as billentity_base_cCode,billtemplate_base.cname as billtemplate_base_cname,billtemplate_base.iTplMode
			from bill_base 
			left join billentity_base on bill_base.id=billentity_base.iBillId and bill_base.tenant_id=billentity_base.tenant_id
			left join billtemplate_base on bill_base.id=billtemplate_base.iBillId and bill_base.tenant_id=billtemplate_base.tenant_id
			where bill_base.cBillNo=@billno and bill_base.tenant_id<>0
			) bill on bill.tenant_id=tenant.id and billentity_base.cCode=bill.billentity_base_cCode and billtemplate_base.cName=bill.billtemplate_base_cname and billtemplate_base.iTplMode=bill.iTplMode
where billtplgroup_base.iBillId in (select id from bill_base where cBillNo=@billno and tenant_id=0);

insert into billitem_base(`makeField`,`sysid`,`iBillId`,`iBillEntityId`,`iTplId`,`iBillTplGroupId`,`cSubId`,`cFieldName`,`cName`,`cCaption`,`cShowCaption`,`iOrder`,`iMaxLength`,`iFieldType`,`bEnum`,`cEnumString`,`isDeleted`,`bMustSelect`,`bHidden`,`cRefType`,`cRefId`,`cRefRetID`,`cDataRule`,`iFunctionType`,`bSplit`,`bExtend`,`iNumPoint`,`bCanModify`,`cSourceType`,`iMaxShowLen`,`cMemo`,`iColWidth`,`cSumType`,`iAlign`,`bNeedSum`,`bShowIt`,`bFixed`,`bFilter`,`cDefaultValue`,`cFormatData`,`cUserId`,`iTabIndex`,`bIsNull`,`bPrintCaption`,`bJointQuery`,`bPrintUpCase`,`bSelfDefine`,`cDataSourceName`,`cOrder`,`bCheck`,`cControlType`,`cEnumType`,`refReturn`,`bShowInRowAuth`,`iRowAuthBillId`,`cStyle`,`bRowAuthControlled`,`cSelfDefineType`,`bVmExclude`,`bRowAuthDim`,`isprint`,`multiple`,`tenant_id`,`isshoprelated`,`depends`,`isExport`) 
select billitem_base.makeField,billitem_base.id,bill.iBillId,bill.iBillEntityId,bill.iTplId,bill.iBillTplGroupId,billitem_base.cSubId,`cFieldName`,billitem_base.cName,`cCaption`,`cShowCaption`,billitem_base.iOrder,`iMaxLength`,`iFieldType`,`bEnum`,`cEnumString`,billitem_base.isDeleted,`bMustSelect`,`bHidden`,`cRefType`,`cRefId`,`cRefRetID`,`cDataRule`,`iFunctionType`,`bSplit`,`bExtend`,`iNumPoint`,`bCanModify`,`cSourceType`,`iMaxShowLen`,billitem_base.cMemo,`iColWidth`,`cSumType`,`iAlign`,`bNeedSum`,`bShowIt`,`bFixed`,`bFilter`,`cDefaultValue`,`cFormatData`,`cUserId`,`iTabIndex`,billitem_base.bIsNull,`bPrintCaption`,`bJointQuery`,`bPrintUpCase`,`bSelfDefine`,billitem_base.cDataSourceName,`cOrder`,`bCheck`,`cControlType`,`cEnumType`,`refReturn`,`bShowInRowAuth`,`iRowAuthBillId`,billitem_base.cStyle,billitem_base.bRowAuthControlled,`cSelfDefineType`,`bVmExclude`,`bRowAuthDim`,billitem_base.isprint,`multiple`,tenant.id,`isshoprelated`,`depends`,billitem_base.isExport
from billitem_base
left join tenant on 1=1
left join bill_base on billitem_base.iBillId=bill_base.id and billitem_base.tenant_id=bill_base.tenant_id
left join billentity_base on billentity_base.iBillId=bill_base.id and billentity_base.tenant_id=bill_base.tenant_id and billitem_base.iBillEntityId=billentity_base.id
left join billtemplate_base on billtemplate_base.iBillId=bill_base.id and billtemplate_base.tenant_id=bill_base.tenant_id and billitem_base.iTplId=billtemplate_base.id
left join billtplgroup_base on billtplgroup_base.iBillId=bill_base.id and billtplgroup_base.tenant_id=bill_base.tenant_id and billtplgroup_base.iBillEntityId=billentity_base.id and billitem_base.iBillTplGroupId=billtplgroup_base.id
left join (select bill_base.id as iBillId,billentity_base.id as iBillEntityId ,billtemplate_base.id as iTplId,
				  billtplgroup_base.id as iBillTplGroupId,bill_base.tenant_id,
					billentity_base.cCode as billentity_base_cCode,billtemplate_base.cname as billtemplate_base_cname,billtemplate_base.iTplMode,
					billtplgroup_base.cCode as billtplgroup_base_cCode
			from bill_base 
			left join billentity_base on bill_base.id=billentity_base.iBillId and bill_base.tenant_id=billentity_base.tenant_id
			left join billtemplate_base on bill_base.id=billtemplate_base.iBillId and bill_base.tenant_id=billtemplate_base.tenant_id
			left join billtplgroup_base on bill_base.id=billtplgroup_base.iBillId and billentity_base.id=billtplgroup_base.iBillEntityId
										and billtemplate_base.id=billtplgroup_base.iTplId and bill_base.tenant_id=billtplgroup_base.tenant_id
			where bill_base.cBillNo=@billno and bill_base.tenant_id<>0 and if(isnull(billtplgroup_base.cCode),'', billtplgroup_base.cCode)<> ''
			) bill on bill.tenant_id=tenant.id and billentity_base.cCode=bill.billentity_base_cCode and billtemplate_base.cName=bill.billtemplate_base_cname 
								and  billtplgroup_base.cCode=bill.billtplgroup_base_cCode 
where billitem_base.iBillId in (select id from bill_base where cBillNo=@billno and tenant_id=0) and if(isnull(billtplgroup_base.cCode),'', billtplgroup_base.cCode)<> '' ;


insert into bill_toolbar(`billnumber`,`name`,`ismain`,`parent`,`align`,`subid`,`system`,`orderNum`,`childrenField`,`tplmode`,`cStyle`,`tenant_id`,`templateType`,`terminalType`) 
select `billnumber`,bill_toolbar.name,`ismain`,`parent`,`align`,`subid`,`system`,`orderNum`,`childrenField`,`tplmode`,`cStyle`,tenant.id,templateType,terminalType
from bill_toolbar 
left join tenant on 1=1 and tenant.id<>0
where billnumber=@billno and tenant_id=0;

insert into bill_toolbaritem(`sysid`,`billnumber`,`toolbar`,`name`,`command`,`type`,`style`,`text`,`parameter`,`imgsrc`,`parent`,`order`,`subid`,`system`,`authid`,`authcontrol`,`authname`,`bMerge`,`icon`,`tenant_id`) 
select bill_toolbaritem.id,`billnumber`,`toolbar`,bill_toolbaritem.name,`command`,`type`,`style`,`text`,`parameter`,`imgsrc`,`parent`,`order`,`subid`,`system`,`authid`,`authcontrol`,`authname`,`bMerge`,`icon`,tenant.id
from bill_toolbaritem
left join tenant on 1=1 and tenant.id<>0
where billnumber=@billno and tenant_id=0;

insert into bill_command(`name`,`action`,`billnumber`,`target`,`ruleid`,`svcurl`,`httpmethod`,`subid`,`system`,`parameter`,`authid`,`tenant_id`) 
select bill_command.name,`action`,`billnumber`,`target`,`ruleid`,`svcurl`,`httpmethod`,`subid`,`system`,`parameter`,`authid`,tenant.id
from bill_command
left join tenant on 1=1 and tenant.id<>0
where billnumber=@billno and tenant_id=0;

##处理报表查询分组方案 非报表不需要处理
##delete rpt_groupitem from rpt_groupitem inner join rpt_groupschema on rpt_groupitem.mainid=rpt_groupschema.id where rpt_groupschema.billnum=@billno and rpt_groupschema.tenant_id<>0;
##delete from rpt_groupschema where  billnum=@billno and tenant_id<>0;

##insert into rpt_groupschema(`billnum`,`name`,`isDefault`,`isCrossTable`,`tenant_id`,sysid,displayStyle,pageLayout,chartConfig, isDisplayZero,`type`,isPc,isMobile) 
##select `billnum`,rpt_groupschema.name,`isDefault`,`isCrossTable`,tenant.id,rpt_groupschema.id,displayStyle,pageLayout,chartConfig, isDisplayZero,`type`,isPc,isMobile
##from rpt_groupschema
##left join tenant on 1=1 and tenant.id<>0
##where billnum=@billno and tenant_id=0;

##insert into rpt_groupitem (mainid,fieldname,groupType,columndefine,entity,showCaption)
##select rpt_groupschema.id,fieldname,groupType,columndefine,entity,showCaption
##from rpt_groupschema inner join (
##			select rpt_groupitem.id,fieldname,groupType,columndefine,entity,rpt_groupschema.billnum,rpt_groupschema.name,rpt_groupitem.showCaption  from rpt_groupschema 
##     left join rpt_groupitem on rpt_groupschema.id=rpt_groupitem.mainid where billnum=@billno and tenant_id=0) item
##			on item.billnum=rpt_groupschema.billnum and rpt_groupschema.name=item.name
##where rpt_groupschema.tenant_id<>0 and rpt_groupschema.billnum=@billno order by item.id;



##更新bill_base的iDefTplId字段
update bill_base left join billtemplate_base on billtemplate_base.iBillId=bill_base.id and billtemplate_base.tenant_id=bill_base.tenant_id
set bill_base.iDefTplId=billtemplate_base.id
where bill_base.cBillNo=@billno and billtemplate_base.iTplMode=@tplmode;
##更新tplgroup的iParentId字段
update billtplgroup_base a
					inner join billtplgroup_base b on a.iParentId=b.sysid and a.tenant_id=b.tenant_id and a.iTplId=b.iTplId
set a.iParentId=b.id
where  if(ISNULL(a.iParentId),'',a.iParentId)<>'' and a.iBillId in (select id from bill_base where cBillNo=@billno and tenant_id<>0) and if(ISNULL(b.id),'',b.id)<>'';
##更新bill_toolbaritem 的parent字段
update bill_toolbaritem a
##select a.Parent,b.id from bill_toolbaritem a
					inner join bill_toolbaritem b on a.Parent=b.sysid and a.tenant_id=b.tenant_id and a.billnumber=b.billnumber
set a.Parent=b.id
where  if(ISNULL(a.Parent),'',a.Parent)<>'' and a.billnumber=@billno and a.tenant_id<>0 and if(ISNULL(b.id),'',b.id)<>'';
##更新非0租户的cFilterId、sysid为0租户的billid ##插入时处理了sysid不用在更新
##update bill_base a ,bill_base b 
##set a.cFilterId=b.cFilterId,a.sysid=b.id 
##where a.cBillNo = b.cBillNo And b.tenant_id = 0 And a.cBillNo = @billno;
##更新非0租户billitem_base的自定义项
Update 
billitem_base 
left join userdef_base on billitem_base.cSelfDefineType=userdef_base.defineId and userdef_base.tenant_id=billitem_base.tenant_id
left join userdef_type on userdef_base.type = userdef_type.deftype
set
billitem_base.cshowcaption=userdef_base.showitem, billitem_base.bHidden=0, billitem_base.bShowIt=1, billitem_base.cControlType=userdef_type.controltype, 
billitem_base.bIsNull=(case when userdef_base.isinput=1 then 0 else 1 END), 
billitem_base.refReturn=(case when userdef_base.type='Archive' then 'name' else NULL END),
billitem_base.cRefType=(case when userdef_base.type='Archive' then 'pb_userdefine' else NULL END)
where iBillId in (select id from bill_base where cbillno=@billno and tenant_id<>0)
and billitem_base.tenant_id<>0 and bSelfDefine=1 and userdef_base.isenabled=1;