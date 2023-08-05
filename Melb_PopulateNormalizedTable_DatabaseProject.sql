BEGIN


create SEQUENCE SEQ_JZ_ME_REGION

INSERT INTO jz_me_region(region_id, region_name)

select SEQ_JZ_ME_REGION.nextval region_id, region_name
from (select distinct region_name
    from jz_me_stage
    minus
    select region_name
    from jz_me_region)

select * from jz_me_region


create SEQUENCE SEQ_JZ_ME_PROPERTY_TYPE

INSERT INTO jz_me_property_type(property_ty_id, property_type)

select SEQ_JZ_ME_PROPERTY_TYPE.nextval property_ty_id, property_type
from (select distinct property_type
    from jz_me_stage
    minus
    select property_type
    from jz_me_property_type)

select * from jz_me_property_type


create SEQUENCE SEQ_JZ_ME_SUBURB

INSERT INTO jz_me_suburb(suburb_id, suburb_name)

select SEQ_JZ_ME_SUBURB.nextval suburb_id, suburb
from (select distinct suburb
    from jz_me_stage
    minus
    select suburb_name
    from jz_me_suburb)

select * from jz_me_suburb


create SEQUENCE SEQ_JZ_ME_COUNCIL

INSERT INTO jz_me_council(council_id, council_area_name)

select SEQ_JZ_ME_COUNCIL.nextval council_id, council_area
from (select distinct council_area
    from jz_me_stage
    where council_area is not null
    minus
    select council_area_name
    from jz_me_council)

select * from jz_me_council


create SEQUENCE SEQ_JZ_ME_SELLING_METHOD

INSERT INTO jz_me_selling_method(selling_method_id, selling_method)

select SEQ_JZ_ME_SELLING_METHOD.nextval selling_method_id, selling_method
from (select distinct selling_method
    from jz_me_stage
    minus
    select selling_method
    from jz_me_selling_method)

select * from jz_me_selling_method


create SEQUENCE SEQ_JZ_ME_SELLER

INSERT INTO jz_me_seller(seller_id, seller_name)

select SEQ_JZ_ME_SELLER.nextval seller_id, seller
from (select distinct seller
    from jz_me_stage
    minus
    select seller_name
    from jz_me_seller)

select * from jz_me_seller


create SEQUENCE SEQ_JZ_ME_PROPERTY

INSERT INTO jz_me_property(property_id, room_number, bed_room, bath_room, car_spots, land_size, building_area, year_built, distance_from_cbd, property_type_id, property_count)

select SEQ_JZ_ME_PROPERTY.nextval property_id, rooms, bedroom2, bathroom, car_spots, land_size, building_area, year_built, distance_to_cbd, property_ty_id, property_count
from (select distinct rooms,
                      bedroom2,
                      bathroom,
                      car_spots,
                      land_size,
                      building_area,
                      year_built,
                      distance_to_cbd,
                      property_ty_id,
                      property_count
                      from jz_me_stage stage
                      left join jz_me_property_type type
                      on (stage.property_type = type.property_type)
                      minus
                      select room_number, bed_room, bath_room, car_spots, land_size, building_area, year_built, distance_from_cbd, property_type_id, property_count
                      from jz_me_property)

select * from jz_me_property



create SEQUENCE SEQ_JZ_ME_ADDRESS

INSERT INTO jz_me_address(address_id, address_name, post_code, lattitude,longtitude, region_id, suburb_id, property_id, council_id)

select SEQ_JZ_ME_ADDRESS.nextval address_id, address, post_code, lattitude,longtitude, region_id, suburb_id, property_id, council_id
from (select address,
        post_code,
        lattitude,
        longtitude,
        region_id,
        suburb_id,
        property_id, 
        council_id
        from jz_me_stage stage
        left join jz_me_property_type ty
        on stage.property_type = ty.property_type
        left join jz_me_region re
        on stage.region_name = re.region_name
        left join jz_me_suburb su
        on stage.suburb = su.suburb_name
        left join jz_me_property pr
        on (stage.rooms=pr.room_number and stage.bedroom2=pr.bed_room and stage.bathroom=pr.bath_room and stage.car_spots=pr.car_spots and 
        stage.land_size=pr.land_size and nvl(stage.building_area,-1) = nvl(pr.building_area ,-1) and nvl(stage.year_built,-1) = nvl(pr.year_built ,-1) and stage.distance_to_cbd=pr.distance_from_cbd
        and ty.property_type = NVL(stage.property_type, 'qwerty'))
        left join jz_me_council cou
        on stage.council_area = cou.council_area_name
        minus
        select address_name, post_code, lattitude,longtitude, region_id, suburb_id, property_id, council_id
        from jz_me_address)
        

select * from jz_me_address
        
create SEQUENCE SEQ_JZ_ME_SELLING_INFO

INSERT INTO jz_me_selling_info(selling_info_id, price_sold, date_sold, property_id, selling_method_id, seller_id)

select SEQ_JZ_ME_SELLING_INFO.nextval selling_info_id, price_sold, date_sold, property_id, selling_method_id, seller_id
from (select price_sold,
        date_sold,
        property_id,
        selling_method_id,
        seller_id
        from jz_me_stage stage
        left join jz_me_property_type ty
        on stage.property_type = ty.property_type
        left join jz_me_property pr
        on (stage.rooms=pr.room_number and stage.bedroom2=pr.bed_room and stage.bathroom=pr.bath_room and stage.car_spots=pr.car_spots and 
        stage.land_size=pr.land_size and nvl(stage.building_area,-1) = nvl(pr.building_area ,-1) and nvl(stage.year_built,-1) = nvl(pr.year_built ,-1) and stage.distance_to_cbd=pr.distance_from_cbd
        and ty.property_type = NVL(stage.property_type, 'qwerty'))
        left join jz_me_seller se
        on stage.seller = se.seller_name
        left join jz_me_selling_method me
        on stage.selling_method = me.selling_method
        minus
        select price_sold, date_sold, property_id, selling_method_id, seller_id
        from jz_me_selling_info)
        

select * from jz_me_stage


select suburb_name, address_name, room_number, property_type, price_sold, selling_method, seller_name, date_sold,  distance_from_cbd, 
        post_code, bed_room, bath_room, car_spots, land_size, building_area, year_built, council_area_name, lattitude, longtitude, 
        region_name, property_count
from jz_me_address ad
right join jz_me_suburb su
on ad.suburb_id = su.suburb_id
right join jz_me_property pr
on pr.property_id = ad.property_id
right join jz_me_property_type ty
on ty.property_ty_id = pr.property_ty_id
right join jz_me_selling_info se
on se.property_id = pr.property_id
right join jz_me_selling_method me
on me.selling_method_id = se.selling_method_id
right join jz_me_seller sel
on sel.seller_id = se.seller_id
right join jz_me_council co
on co.council_id = ad.council_id
right join jz_me_region re
on re.region_id = ad.region_id
order by suburb_name

  
COMMIT;

END;
/
