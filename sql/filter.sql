set @billno='rm_billingmembers';
set @tenant_id='1137687541223680';

SELECT cFilterId into @filterid from bill_base where cBillNo=@billno and tenant_id=@tenant_id;

SELECT * from pb_meta_filters where id=@filterid;

SELECT * from pb_meta_filter_item where filtersId=@filterid;

SELECT * from pb_filter_solution where filtersId=@filterid and tenant_id=@tenant_id;

SELECT id into @solutionid from pb_filter_solution where filtersId=@filterid and tenant_id=@tenant_id;

SELECT * from pb_filter_solution_common where solutionId=@solutionid;