CLASS lhc_zi_saler DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR zi_saler RESULT result.

    METHODS generate_sellerID FOR NUMBERING
        IMPORTING entities FOR CREATE zi_saler.

    METHODS generate_materialID FOR NUMBERING
        IMPORTING entities FOR CREATE zi_saler\_material.

ENDCLASS.

CLASS lhc_zi_saler IMPLEMENTATION.

    METHOD get_instance_authorizations.
    ENDMETHOD.

    METHOD generate_SellerId.
        "table reference.
        DATA(lt_entities) = entities.
        " check and delete the entities where the seller id is not initial.
        DELETE lt_entities WHERE SalerId IS NOT INITIAL.

        " get the next number as per the number range object created for that BO.
        TRY.
            cl_numberrange_runtime=>number_get(
            EXPORTING
            nr_range_nr = '01' " add by 1
            object = '/DMO/TRV_M' "number range Object.
            quantity = CONV #( lines( lt_entities ) ) " no of instances
            IMPORTING
            number = DATA(lv_seller_id) "new seller id
            returncode = DATA(lv_code)
            returned_quantity = DATA(lv_qty)
            ).
        CATCH cx_nr_object_not_found.
        CATCH cx_number_ranges INTO DATA(lo_error).
                "Find the failed and reported cases.
            LOOP AT lt_entities INTO DATA(ls_entities).
                "if failed
                APPEND VALUE #( %cid = ls_entities-%cid
                                %key = ls_entities-%key )
                                TO failed-zi_saler.
                " if reported
                APPEND VALUE #( %cid = ls_entities-%cid
                                %key = ls_entities-%key )
                                TO reported-zi_saler.
            ENDLOOP.
            EXIT.
        ENDTRY.
        " assertion
        ASSERT lv_qty = lines( lt_entities ).
        DATA(lv_curr_sellerid) = lv_seller_id - lv_qty.
        LOOP AT lt_entities INTO ls_entities.
            lv_curr_sellerid = lv_curr_sellerid + 1.

            APPEND VALUE #( %cid = ls_entities-%cid
                        salerid = lv_curr_sellerid )
                        TO mapped-zi_saler.
        ENDLOOP.
    ENDMETHOD.

    " generate the material id based on the seller id.
    METHOD generate_materialID.
        DATA: max_no TYPE zmatno.

        " read the entities by associated links
        READ ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_saler BY \_material
            FROM CORRESPONDING #( entities )
        LINK DATA(lt_link_data).

    " loop over all unique %tky --> for seller id and material id
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>) GROUP BY <fs_entity>-SalerId.
            "get the highest material id
            max_no = REDUCE zbookallotids(
                    INIT lv_max = 0
                    FOR ls_link IN lt_link_data
                    USING KEY entity
                    WHERE ( source-SalerId = <fs_entity>-SalerId )
                    NEXT lv_max = COND zmatno(
                                    WHEN lv_max < ls_link-target-MaterialNumber
                                    THEN ls_link-target-MaterialNumber
                                    ELSE lv_max ) ).

        "get the highest material id from incoming entities
        max_no = REDUCE zbookallotids(
                    INIT lv_max1 = max_no
                    FOR ls_entity IN entities
                    USING KEY entity
                    WHERE ( SalerId = <fs_entity>-SalerId )
                    FOR ls_sellerid IN ls_entity-%target
                    NEXT lv_max1 = COND zmatno(
                                    WHEN lv_max1 < ls_sellerid-MaterialNumber
                                    THEN ls_sellerid-MaterialNumber
                                    ELSE lv_max1 ) ).

        " get the entities using seller id
            LOOP AT entities ASSIGNING FIELD-SYMBOL(<fls_entities>)
                USING KEY entity
                WHERE SalerId = <fs_entity>-SalerId.
    
                " check  in the target entity
                LOOP AT <fls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_materialId>).
                    IF <ls_materialId>-MaterialNumber IS INITIAL.  " check material number and assign the new material number to the entity
                        max_no +=  1.
                        APPEND CORRESPONDING #( <ls_materialId> ) TO mapped-zi_materal ASSIGNING FIELD-SYMBOL(<ls_new_materialId>).
                        <ls_new_materialId>-MaterialNumber = max_no.
                    ENDIF.
                ENDLOOP.
            ENDLOOP.
        ENDLOOP.
    ENDMETHOD.
ENDCLASS.