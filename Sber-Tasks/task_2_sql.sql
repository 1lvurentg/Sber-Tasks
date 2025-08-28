select -- первое условие
	th.inn::text,
    th.credit_num,
    th.account,
    th.operation_datetime,
    th.operation_sum,
    th.doc_id,
    tr.operation_datetime,
    tr.operation_sum 
from tranches th
	join transactions tr
	on tr.inn::text = th.inn
	and tr.account = th.account
 	and tr.operation_sum = th.operation_sum
    and tr.operation_datetime between th.operation_datetime and th.operation_datetime + interval '10 days'
	where DATE_PART('year', th.operation_datetime) = 2024

union all

select -- второе условие
	th.inn::text,
    th.credit_num,
    th.account,
    th.operation_datetime,
    th.operation_sum,
    th.doc_id,
    NULL::timestamp,
    sum(tr.operation_sum)
from tranches th
	join transactions tr
	on tr.inn::text = th.inn
	and tr.account = th.account
 	and tr.operation_datetime between th.operation_datetime and th.operation_datetime + interval '10 days'
	where DATE_PART('year', th.operation_datetime) = 2024
	and not exists(
		select * from transactions tr2
		where tr2.inn::text = th.inn
		and tr2.account = th.account
		and tr2.operation_sum = th.operation_sum
		and tr2.operation_datetime between th.operation_datetime and th.operation_datetime + interval '10 days'
        and DATE_PART('year', th.operation_datetime) = 2024
	)
    group by th.inn::text, th.credit_num, th.account, th.operation_datetime, th.operation_sum, th.doc_id
	having sum(tr.operation_sum) >= th.operation_sum;

