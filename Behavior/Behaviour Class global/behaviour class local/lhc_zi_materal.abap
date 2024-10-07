CLASS lhc_zi_materal DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR zi_materal RESULT result.

    METHODS earlynumbering_cba_Images FOR NUMBERING
        IMPORTING entities FOR CREATE zi_materal\_Images.

    METHODS matavailable FOR MODIFY
        IMPORTING keys FOR ACTION zi_materal~matavailable RESULT result.

    METHODS matnotavailable FOR MODIFY
        IMPORTING keys FOR ACTION zi_materal~matnotavailable RESULT result.
    
        METHODS get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR zi_materal RESULT result.

    METHODS validate_seller FOR VALIDATE ON SAVE
        IMPORTING keys FOR zi_materal~validate_seller.

*    METHODS validate_status FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zi_materal~validate_status.

    METHODS validate_amount FOR VALIDATE ON SAVE
        IMPORTING keys FOR zi_materal~validate_amount.

    METHODS recalculate_price FOR MODIFY
        IMPORTING keys FOR ACTION zi_materal~recalculate_price.

    METHODS total_price_calc FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zi_materal~total_price_calc.

ENDCLASS.

CLASS lhc_zi_materal IMPLEMENTATION.

    "generate the image number and id for the images to be uploaded.
    METHOD earlynumbering_cba_Images.
        DATA: max_no TYPE zimgid.
        " read the entities by associated links
        READ ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_materal BY \_images
            FROM CORRESPONDING #( entities )
        LINK DATA(lt_link_images).

        " loop over all unique %tky --> for seller id and Image id
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>) GROUP BY <fs_entity>-%tky.

            "get the highest image id from material belonging to materials
            max_no = REDUCE #(
                    INIT lv_max = 0
                    FOR ls_image IN lt_link_images
                    USING KEY entity
                    WHERE ( source-MaterialNumber = <fs_entity>-MaterialNumber
                            and source-Salerid = <fs_entity>-Salerid )
                    NEXT lv_max = COND zimgid(
                                    WHEN lv_max < ls_image-target-ImageNumber
                                    THEN ls_image-target-ImageNumber
                                    ELSE lv_max ) ).

            "get the highest image id from incoming entities
            max_no = REDUCE #(
                        INIT lv_max1 = max_no
                        FOR ls_entity IN entities
                        USING KEY entity
                        WHERE ( MaterialNumber = <fs_entity>-MaterialNumber
                                and Salerid = <fs_entity>-Salerid )
                        FOR ls_imageid IN ls_entity-%target
                        NEXT lv_max1 = COND zimgid(
                                        WHEN lv_max1 < ls_imageid-ImageNumber
                                        THEN ls_imageid-ImageNumber
                                        ELSE lv_max1 ) ).

            "loop over all entries in entities with same Seller id and Material Id
            LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_material>)
                USING KEY entity
                WHERE MaterialNumber = <fs_entity>-MaterialNumber
                and Salerid = <fs_entity>-Salerid.
    
            " check  in the target entity
                LOOP AT <fs_material>-%target ASSIGNING FIELD-SYMBOL(<ls_ImageId>).
                    IF <ls_ImageId>-ImageNumber IS INITIAL.  " check Image number and assign the new material number to the entity
                    max_no +=  1.
                    APPEND CORRESPONDING #( <ls_ImageId> ) TO mapped-zi_images ASSIGNING FIELD-SYMBOL(<ls_new_ImageId>).
                    <ls_new_ImageId>-ImageNumber = max_no.
                    ENDIF.
                ENDLOOP.
            ENDLOOP.
        ENDLOOP.
    ENDMETHOD.

    " make the Material Available
    METHOD matavailable.
        MODIFY ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_materal UPDATE FIELDS ( Status )
            WITH VALUE #(  FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                                Status = 'A' ) 
        ).

        READ ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_materal
            ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

        result = VALUE #( FOR ls_result IN lt_result  ( %tky = ls_result-%tky
                                                        %param = ls_result ) ).
    ENDMETHOD.

    " make the Material Not Available
    METHOD matnotavailable.
        MODIFY ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_materal UPDATE FIELDS ( Status )
            WITH VALUE #(  FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                                Status = 'NA' ) 
        ).

        READ ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_materal
            ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

        result = VALUE #( FOR ls_result IN lt_result  ( %tky = ls_result-%tky
                                                        %param = ls_result ) ).
    ENDMETHOD.

    " Authorization method implemented
    METHOD get_instance_authorizations.
    ENDMETHOD.

    " feature control in material maintenance
    METHOD get_instance_features.
        READ ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_saler BY \_material
            FIELDS ( Salerid Status )
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_saler).

        result = VALUE #( FOR ls_saler IN lt_saler
                        ( %tky = ls_saler-%tky
                            %features-%action-matavailable = COND #( WHEN ls_saler-Status = 'A'
                                                                    THEN if_abap_behv=>fc-o-disabled
                                                                    ELSE if_Abap_behv=>fc-o-enabled )
                            %features-%action-matnotavailable = COND #( WHEN ls_saler-Status = 'NA'
                                                                    THEN if_abap_behv=>fc-o-disabled
                                                                    ELSE if_Abap_behv=>fc-o-enabled ) ) ).
    ENDMETHOD.


    " validate the seller id.
    METHOD validate_seller.
        DATA : lt_sellers TYPE SORTED TABLE OF zsalers_table WITH UNIQUE KEY saler_id.

        " read the entity.
        READ ENTITY IN LOCAL MODE zi_saler
            FIELDS ( SalerId )
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_seller).

        " insert data into the lt_Sellers data.
        lt_Sellers = CORRESPONDING #( lt_seller DISCARDING DUPLICATES MAPPING saler_id = SalerId ).

        "delete the entities where seller id is initial from lt_seller.
        DELETE lt_seller WHERE salerid IS INITIAL.

        "select from the table where seller id is equal to the seller id's present in lt_seller.
        SELECT  FROM zsalers_table
        FIELDS saler_id
            FOR ALL ENTRIES IN @lt_sellers
            WHERE saler_Id = @lt_sellers-Saler_Id
        INTO TABLE @DATA(lt_sellers_found).

        IF sy-subrc IS INITIAL.
        ENDIF.

        LOOP AT lt_seller ASSIGNING FIELD-SYMBOL(<fs_seller>).
            "check id seller id is initial or check a entry exists of seller id in lt_seller table.
            IF <fs_seller>-SalerId IS INITIAL
                OR NOT line_exists( lt_Seller[ salerid = <fs_seller>-SalerId ] ).
                " append value to the failed table and
                APPEND VALUE #(  %tky = <fs_seller>-%tky ) TO failed-zi_saler.
                " reported table
                APPEND VALUE #( %tky = <fs_seller>-%tky ) TO reported-zi_saler.
            ENDIF.
        ENDLOOP.
    ENDMETHOD.

*  METHOD validate_status.
*    "read the material table for the status.
*    READ ENTITY IN LOCAL MODE zi_materal
*            FIELDS ( Status )
*            WITH CORRESPONDING #( keys )
*            RESULT DATA(lt_Status).
*
*    "validate the status.
*    LOOP AT lt_Status INTO DATA(ls_status).
*      CASE ls_status-Status.
*        WHEN 'A'. " available
*        WHEN 'NA'. " not available
*        WHEN OTHERS.
*          APPEND VALUE #( %tky = ls_status-%tky ) TO failed-zi_materal.
*          APPEND VALUE #( %tky = ls_status-%tky
*                          %msg = new_message_with_text( text = 'Only A and NA is acceptable for status' )
*                          ) TO reported-zi_materal.
*      ENDCASE.
*    ENDLOOP.
*  ENDMETHOD.

    METHOD validate_amount.
        "read the material table for the status.
        READ ENTITY IN LOCAL MODE zi_materal
                FIELDS ( Price )
                WITH CORRESPONDING #( keys )
        RESULT DATA(lt_price).

        "validate the status.
        LOOP AT lt_price INTO DATA(ls_price).
            IF ls_price-Price EQ 0.
                APPEND VALUE #( %tky = ls_price-%tky ) TO failed-zi_materal.
                APPEND VALUE #( %tky = ls_price-%tky
                                %msg = new_message_with_text( text = 'Amount can not be equal to 0' )
                                ) TO reported-zi_materal.
            ENDIF.
            IF ls_price-Price < 0.
                APPEND VALUE #( %tky = ls_price-%tky ) TO failed-zi_materal.
                APPEND VALUE #( %tky = ls_price-%tky
                                %msg = new_message_with_text( text = 'Amount can not be less than or equal to 0' )
                                ) TO reported-zi_materal.
            ENDIF.
        ENDLOOP.
    ENDMETHOD.

    "calculate the total amount. --> internal action
    METHOD recalculate_price.

        READ ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_saler BY \_material
            FIELDS ( Price Quantity )
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_material).

        LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_mat>).
        <fs_mat>-TotalPrice = <fs_MAT>-price * <fs_MAT>-Quantity.
        ENDLOOP.

        MODIFY ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_materal
            UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( lt_material ).
    ENDMETHOD.


    " determination calling internal action to calculate total price.
    METHOD Total_price_calc.
        DATA: lt_material TYPE STANDARD TABLE OF zi_saler WITH UNIQUE HASHED KEY key COMPONENTS SalerId.
        lt_material = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING SalerId = Salerid  ).
        MODIFY ENTITIES OF zi_saler IN LOCAL MODE
            ENTITY zi_MATERAL
            EXECUTE recalculate_price
        FROM CORRESPONDING #( lt_material ).
    ENDMETHOD.
ENDCLASS.