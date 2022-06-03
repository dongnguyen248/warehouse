$(document).ready(function () {
    $('#InpectionDate')
.datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
});
    $('#txtPur_Date')
.datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
});
    $('#txtExportDate')
    .datepicker({
        format: 'yyyy-mm-dd',
        autoclose: true
    });
    $('#txtPur_Date')
   .datepicker({
       format: 'yyyy-mm-dd',
       autoclose: true
   });
    $('#txtImpDate,#txtInspDt')
.datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
});
    var table = $('#tbMainDefault').DataTable({
        responsive: true,
        sort: false,
        "processing": true,
        "serverSide": true,
        "searching": true,
        "iDisplayLength": 12,
        ajax: {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Paging/DefaultPage.aspx/Data",
            data: function (d) {
                return JSON.stringify({ parameters: d, query: $('#hdQuery').val() });
            }
        },

        "footerCallback": function (row, data, start, end, display) {
        console.log([row, data, start, end, display]);
        var api = this.api(), data;

            // Remove the formatting to get integer data for summation
        var intVal = function (i) {
            return typeof i === 'string' ?
                i.replace(/[\$,]/g, '') * 1 :
                typeof i === 'number' ?
                i : 0;
        };
            // Total over all pages
        total = api
            .column(7)
            .data()
            .reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);
            // Total over this page
        pageTotal = api
            .column(7, { page: 'current' })
            .data()
            .reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            // Update footer
        $(api.column(7).footer()).html(
            '' + pageTotal
            //+ ' ( $' + total + ' total)'
        );
    }
    });
    $("#tbMainDefault").on('click', 'tr', function (e) {
        if (!$(this).parent("thead").is('thead')) {
            $("tr").removeClass("success");
            $(this).addClass("success");
            if (!$(e.target).is('#tbMainDefault td input:checkbox')) {
                $(this).find('input:checkbox').trigger('click');
            }
        }
    });
    $("#tbMainDefault").on('change', '.ckb', function () {
        var group = ":checkbox[class='" + $(this).attr("class") + "']";
        if ($(this).is(':checked')) {
            $(group).not($(this)).attr("checked", false);
        }
    });
    $("#dvcode").hide();
    $("#dvwork_common").hide();
    $("#selLine").on('change', function () {
        var value = $.trim($('#selLine').val());
        $("#dvcode").hide();
        $("#dvwork_common").hide();
        if (value == "FACTORY #1" || value == "FACTORY #2") {
            $("#dvcode").show();
            $("#dvwork_common").hide();
        } else
            if (value == "WORK-COMMON") {
                $("#dvwork_common").show();
                $("#dvcode").hide();
            }
    });
    $("#dvother").hide();
    $("#dvNote").hide();
    $("#dvRemark").hide();
    $("#txtRemark").on('change', function () {
        var value = $.trim($('#txtRemark').val());
        $("#dvRemark").hide();
        if (value == "Other") {
            $("#dvRemark").show();
            $('#txtRemark2').val("");
        }
    });
    $("#txtCostAcount").on('change', function () {
        var value = $.trim($('#txtCostAcount').val());

        $("#dvother").hide();
        if (value == "Others") {
            $("#dvother").show();
            $("#dvNote").hide();
        } else {
            $("#dvNote").show();
            $("#SelNote").empty();
            if (value == "602011-0000") {
                $("#SelNote").append('<option>--</option> <option>CNG</option> <option>N2</option> <option>NH3</option>');
            }
            else
                if (value == "602021-0000") {
                    $("#SelNote").append('<option>--</option> <option>KRAFT PAPER</option> <option>PE FOR APL, STL</option> <option>PAPER SPOOL</option> <option>G/STONE</option> <option>ALKALI</option> <option>ACID-APL</option> <option>WATER TREAT</option> <option>SALT</option> <option>ETC-PRO</option> <option>ROLL</option><option>ROLLING OIL</option><option>BACKUP BEARING</option> <option>ANODE</option><option>OIL FILTER</option>');
                }
                else
                    if (value == "602031-0000") {
                        $("#SelNote").append('<option>--</option> <option>OIL</option> <option>BEARING</option> <option>ELECTRIC SPARE</option> <option>MECHANICAL SPARE</option> <option>TOOL</option> <option>ETC-MAINT</option>');
                    }
                    else
                        if (value == "602041-0000") {
                            $("#SelNote").append('<option>--</option> <option>PE COVER</option> <option>IN-OUTER RING</option> <option>STEEL BAND</option> <option>WOODEN PALLET</option> <option>WATER PROOF, VINYL, ETC</option>');
                        }
                        else {
                            $("#dvNote").hide();
                        }
        }
    });
    $("#dvLine").hide();
    $("#txtReceiver").on('change', function () {
        var value = $.trim($('#txtReceiver').val());
        $("#dvLine").hide();
        if (value == "Others") {
            $("#dvLine").show();
        }
    });
    $("#dvImpLine").hide();
    $("#txtImp_Receiver").on('change', function () {
        var value = $.trim($('#txtImp_Receiver').val());
        $("#dvImpLine").hide();
        if (value == "Others") {
            $("#dvImpLine").show();
        }
    });
    $('#btnGenerate').click(function () {
        $('#dvbarcode').html('');
        var txtQcode = $("#QCode").val();
        var Pur_Date = $("#txtPur_Date").val().replace("-", "").replace("-", "");
        var Qcode = txtQcode + "-" + Pur_Date;
        // alert(Qcode);
        if (Qcode != "" && Pur_Date.length >= 8) {
            $("#hdbarcode").val(Qcode);
            //alert("generate");
            $.ajax({
                url: 'Services/DefaultService.asmx/GenerateBarcode',
                data: JSON.stringify({
                    Qcode: Qcode
                }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    // alert(rs);
                    if (rs > 0) {
                        //   bootbox.alert("ok " + status);

                        //  $('#frmModify')[0].reset();
                        //   table.ajax.reload(null, false);
                        // window.location.reload(true);
                    }
                    return false;
                },
                error: function (xhr, status, error) {
                    console.log(xhr.status + error);
                    bootbox.alert("Error!" + xhr.status + error);
                    return false;
                },
            }).done(function () {
                // alert(Qcode);
                //  var ran = Math.floor((Math.random() * 10000) + 1);
                $('#dvbarcode').prepend('<a href="FileUploadHandler.ashx?file=' + Qcode + '"><img id="theImg" src="./BarCode/' + Qcode + '.png"/></a>');
            });;
        } else
            if (txtQcode == "") {
                alert("Bạn chưa nhập Qcode!");
                return false;
            } else
                if (Pur_Date == "") {
                    alert("Bạn chưa nhập import date!");
                    return false;
                }
    });
    //$("#tbMainDefault").on('click', 'tr', function (e) {
    //    var index = $(this).index();
    //    if (!$(this).parent("thead").is('thead')) {
    //        $("tr").removeClass("success");
    //        $(this).addClass("success");
    //        //tomau(index);
    //        if (!$(e.target).is('#tbMainDefault td input:checkbox'))
    //            $(this).find('input:checkbox').trigger('click');
    //    }
    //});
    //$("#tbMainDefault").on('change', '.chk', function () {
    //    var group = ":checkbox[class='" + $(this).attr("class") + "']";
    //    if ($(this).is(':checked')) {
    //        $(group).not($(this)).attr("checked", false);
    //    }
    //});
    //$('#btnEditlist').click(function () {
    //    $('#modalEditlist').modal();
    //    return false;
    //});
    $('#btnAdd').click(function () {
        //alert("ADD");
        $('#frmModify')[0].reset();
        $('#action').val(0);
        $('#Price').text(0);
        $('#Total').text(0);
        $('#title').html('<span class="glyphicon glyphicon-file"></span>Import Material');
        var nowdate = $.trim($('#txtNow').val());
        $('#txtPur_Date').val(nowdate);
        $('#txtPO').val("");
        $('#txtLocator').val("QMA01.");
        $('#Qty').removeAttr('disabled');
        $('#Price').removeAttr('disabled');
        $('#txtPur_Date').removeAttr('disabled');
        $("#txtSupplier").removeAttr('disabled');
        $("#txtBuyer").removeAttr('disabled');
        $("#txtReceiver").removeAttr('disabled');
        //------Thanh edit
        $('#chkinpection').prop('checked', false);
        $("#InpectionDate").removeAttr('disabled');
        $("#Inpector").removeAttr('disabled');
        $("#InpectionResult").removeAttr('disabled');
        //-------end edit
        $("#txtLocator").removeAttr('disabled');
        $('#txtPO').removeAttr('disabled');
        $('#chknhan').prop('checked', false);
        $('#chkinpection').prop('checked', false);
        $('#dvbarcode').empty();
        $('#mdModify').modal({ backdrop: 'static', keyboard: false });
        return false;
    });

    // ---------- select Zone -------------------- //
    function GetZoneValue() {
        var optionSelected = $("#Zone").find("option:selected");

        return valueSelected = optionSelected.val();
    }

    $("#Zone").change(function () {
        var valueSelected = GetZoneValue();

        $('#txtLocator').val("QMA01." + valueSelected);
    });

    $('#Location').change(function () {
        var valueSelected = GetZoneValue();

        if (valueSelected == -1) {
            $('#Location').val("");
            $('#Zone').focus();
        }
        else {
            var location = $.trim($('#Location').val());

            $('#txtLocator').val("QMA01." + valueSelected + "-" + location);
        }
    });

    // ----------------- end ----------------------//


    $('#dvlogout').click(function () {
        $.ajax({
            url: 'Services/DefaultService.asmx/LogOut',
            //data: JSON.stringify({
            //    QCode: QCode, Zone: Zone, Location: Location, Item: Item, Spec: Spec, Unit: Unit, Price: Price, Qty: Qty, Remark: Remark
            //}),
            type: 'POST',
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            crossBrowser: true,
            success: function (data, status) {
                window.location.reload();
                return false;
            },
            error: function (xhr, status, error) {
                bootbox.alert("Error!" + xhr.status);
            },
        });
    });
    //allocate
    $("#btnallocate").click(function () {
        if ($("#tbMainDefault input:checkbox:checked").length > 0) {
            var checkbox = $("#tbMainDefault tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            //  var id = $.trim(tr.children("td:nth-child(1)").find(".id").val());
            var QCode = tr.children("td:nth-child(4)").text();
            var Pur_Date = tr.children("td:nth-child(10)").text();
            var Qty = tr.children("td:nth-child(8)").text();
            var price = tr.children("td:nth-child(9)").text();
            var locator = tr.children("td:nth-child(13)").text();
            $("#hdprice").val(price);
            $("#txtQcode").val(QCode);
            $("#txtImport_Date").val(Pur_Date);
            $("#txtQcode").attr('disabled', 'disabled');
            $("#txtImport_Date").attr('disabled', 'disabled');
            $("#hdQuantity").val();
            $("#txtInvenQty").val(Qty);
            $("#txtInvenQty").attr('disabled', 'disabled');
            $("#selLine").val("");
            $("#txtQuantity").val("");
            $("#txtRequestor").val();
            $('#txtExportDate').val($('#txtNow').val());
            $("#SelNote").val("");
            $("#txtCostAcount").val("");
            $("#selCommon").val("");
            $("#txtNote1").val("");
            $("#txtother").val("");
            $("#dvNote").hide();
            $("#dvRemark").hide();
            $("#dvwork_common").hide();
            $("#txtRequestor").val("");
            $("#txtRemark").val("");
            $("#txtlocator").val(locator);
            $('#modalAllocate').modal({ backdrop: 'static', keyboard: false });
        }
        else {
            alert("Please select a material to allocate");
        }
    });
    //import 
    $("#btnImport").click(function () {
        if ($("#tbMainDefault input:checkbox:checked").length > 0) {
            var checkbox = $("#tbMainDefault tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var QCode = tr.children("td:nth-child(4)").text();
            var Pur_Date = $.trim(tr.children("td:nth-child(11)").text());
            var locator = $.trim(tr.children("td:nth-child(13)").text());

            var nowdate = $('#txtNow').val();
            $('#hdimportdate').val(Pur_Date);
            $('#txtImp_QCode').val(QCode);
            $("#txtImp_QCode").attr('disabled', 'disabled');
            $('#txtImpDate').val(nowdate);
            $('#txtQty').val("");
            $('#txtPrice').val("");
            $('#txtImp_Supplier').val("");
            $('#txtImp_Buyer').val("");
            $('#txtLocator2').removeAttr('disabled');
            if (locator != "") {
                $('#txtLocator2').val(locator);
            }
            else {
                $('#txtLocator2').val("QMA01.");
            }
            $('#chknhan2').prop('checked', false);


            $('#modalImport').modal();
        }
    });
    //import save data
    $("#btnImpSave").click(function () {
        var QCode = $.trim($('#txtImp_QCode').val());
        var Imp_date = $.trim($('#txtImpDate').val()).replace("-", "").replace("-", "");
        var out_date = $.trim($('#txtExportDate').val());
        var txtQty = $.trim($('#txtQty').val()).replace(",", ".");
        var txtPrice = $.trim($('#txtPrice').val()).replace(",", ".");
        var txtImp_Supplier = $.trim($('#txtImp_Supplier').val());
        var txtImp_Buyer = $.trim($('#txtImp_Buyer').val());
        var txtImp_Receiver = $.trim($('#txtImp_Receiver').val());
        //----Thanh edit       

        var chk_Inpection = '';
        if ($('#chkInsp').is(':checked')) {

            chk_Inpection = 'O';
        } else {

            chk_Inpection = 'X';
        }
        var Inpection_date = $.trim($('#txtInspDt').val()).replace("-", "").replace("-", "");
        var txtInpector = $.trim($('#txtInspector').val());
        var txtResultInpection = $.trim($('#InspectRes').val());

        //----- End Edit
        var locator = $.trim($('#txtLocator2').val());
        if (txtImp_Receiver == "Others") {
            txtImp_Receiver = $.trim($('#txtImpNhan').val());
        }
        var Po = $.trim($('#txtPo').val());
        var Get = "";
        if ($('input[name="chknhan2"]').is(':checked')) {
            Get = "1";
        } else {
            Get = "0";
        }
        if (isNaN(txtQty)) {
            alert("Số lượng phải là số!");
            $('#txtQty').focus();
            return false;
        }
        else
            if (parseFloat(txtQty) <= 0) {
                alert("Số lượng phải lớn hơn 0!");
                $('#txtQty').focus();
                return false;
            }
            else
                if (txtPrice == "") {
                    alert("Bạn phải nhập giá!");
                    $('#txtPrice').focus();
                    return false;
                }
                else
                    if (isNaN(txtPrice)) {
                        // alert(txtPrice);
                        alert("Giá phải là số!");
                        $('#txtPrice').focus();
                        return false;
                    }
                    else
                        if (Imp_date == "") {
                            alert("Bạn chưa nhập ngày nhập hàng!");
                            $('#txtImpDate').focus();
                            return false;
                        }
                        else {
                            $.ajax({
                                url: 'Services/DefaultService.asmx/ImportMaterial',
                                data: JSON.stringify({
                                    QCode: QCode, Imp_date: Imp_date, txtQty: txtQty, txtPrice: txtPrice, Po: Po, txtImp_Supplier: txtImp_Supplier, txtImp_Buyer: txtImp_Buyer,
                                    txtImp_Receiver: txtImp_Receiver, Get: Get, locator: locator,
                                    INSPECTION: chk_Inpection, INSPECTION_DATE: Inpection_date, INSPECTOR: txtInpector, RESULT: txtResultInpection
                                }),
                                type: 'POST',
                                dataType: 'json',
                                contentType: 'application/json; charset=utf-8',
                                crossBrowser: true,
                                success: function (data, status) {
                                    var rs = data.d;
                                    // alert(rs);
                                    if (rs > 0) {
                                        bootbox.alert("Alocate " + status);
                                        $('#modalImport').modal('hide');

                                        //  $('#frmModify')[0].reset();
                                        table.ajax.reload(null, false);
                                        // window.location.reload(true);
                                    }
                                    return false;
                                },
                                error: function (xhr, status, error) {
                                    console.log(xhr.status + error);
                                    bootbox.alert("Error!" + xhr.status + error);
                                    return false;
                                },
                            });
                        }
        return false;
    });
    //allocate save data
    $("#btnOut").click(function () {
        var QCode = $.trim($('#txtQcode').val());
        var import_date = $.trim($('#txtImport_Date').val()).replace("-", "").replace("-", "");
        var out_date = $.trim($('#txtExportDate').val());
        var txtLine = $.trim($('#selLine').val());
        var txtQuantity = $.trim($('#txtQuantity').val()).replace(",", ".");
        var txtRequestor = $.trim($('#txtRequestor').val());
        var hQty = $.trim($('#hdQuantity').val()).replace(",", ".");
        var txtInvenQty = $.trim($('#txtInvenQty').val());
        var txtCostAcount = $.trim($('#txtCostAcount').val());
        var txtRemark = $.trim($('#txtRemark').val());
        var txtCodeCenter = "";
        var txtNote = "";
        var locator = $.trim($('#txtlocator').val());
        var price = $.trim($('#hdprice').val());
        if (txtLine == "FACTORY #1" || txtLine == "FACTORY #2") {
            txtCodeCenter = $.trim($('#txtCodeArea').val());
        } else
            if (txtLine == "WORK-COMMON") {
                txtCodeCenter = $('#selCommon').val();
                // alert(txtCodeCenter);
            }
        if (txtRemark == "Other") {
            txtRemark = $.trim($('#txtRemark2').val());
        }
        if (txtCostAcount == "Others") {
            txtCostAcount = $.trim($('#txtother').val());
            txtNote = $.trim($('#txtNote1').val());
        }
        else {
            if (txtCostAcount != "606191-2802") {
                txtNote = $.trim($('#SelNote').val())
            }
        }
        if (txtNote == "--") {
            alert("Bạn phải chọn cột Note");
            return false;
        } else
            if (txtQuantity == "") {
                alert("Bạn phải nhập số lượng!");
                $('#txtQuantity').focus();
                return false;
            }
            else
                if (isNaN(txtQuantity)) {
                    alert("Số lượng phải là số!");
                    $('#txtQuantity').focus();
                    return false;
                }
                else
                    if (parseFloat(txtQuantity) <= 0) {
                        alert("Số lượng phải lớn hơn 0!");
                        $('#txtQuantity').focus();
                        return false;
                    }
                    else
                        if (parseFloat(txtQuantity) > parseFloat(txtInvenQty)) {
                            alert("Số lượng cấp lớn hơn thực tế trong kho!");
                            $('#txtQuantity').focus();
                            return false;
                        }
                        else if (txtLine == "") {
                            alert("Bạn chưa chọn line!");

                            return false;
                        }
                        else
                            if (txtCostAcount == "") {
                                alert("Bạn chưa nhập mã kế toán!");
                                $('#txtCostAcount').focus();
                                return false;
                            }
                            else
                                if (out_date == "") {
                                    alert("Bạn chưa nhập ngày xuất");
                                    $('#txtExportDate').focus();
                                    return false;
                                }
                                else
                                    if ((txtLine == "FACTORY #1" || txtLine == "FACTORY #2" || txtLine == "WORK-COMMON") && txtCodeCenter == "") {
                                        alert("Bạn chưa nhập mã Code Center");
                                        return false;
                                    }
                                    else {
                                        // alert(txtLine);
                                        $.ajax({
                                            url: 'Services/DefaultService.asmx/OutPut',
                                            data: JSON.stringify({
                                                //  public int OutPut(string QCode,string import_date, string  out_date,string txtLine,string txtQuantity,string txtRequestor,string hQty)
                                                QCode: QCode, import_date: import_date, out_date: out_date, txtLine: txtLine, txtInvenQty: txtInvenQty, txtQuantity: txtQuantity, txtCostAcount: txtCostAcount, txtRequestor: txtRequestor, txtRemark: txtRemark, txtCodeCenter: txtCodeCenter, txtNote: txtNote, price: price, locator: locator
                                            }),
                                            type: 'POST',
                                            dataType: 'json',
                                            contentType: 'application/json; charset=utf-8',
                                            crossBrowser: true,
                                            success: function (data, status) {
                                                var rs = data.d;
                                                //alert(rs);
                                                if (rs > 0) {
                                                    bootbox.alert("Alocate " + status);
                                                    $('#modalAllocate').modal('hide');

                                                    //  $('#frmModify')[0].reset();
                                                    table.ajax.reload(null, false);
                                                    // window.location.reload(true);
                                                }
                                                return false;
                                            },
                                            error: function (xhr, status, error) {
                                                console.log(xhr.status + error);
                                                bootbox.alert("Error!" + xhr.status + error);
                                                return false;
                                            },
                                        });
                                    }
        return false;
    });
    //mdModify
    $("#btnModify").click(function () {
        if ($("#tbMainDefault input:checkbox:checked").length > 0) {

            var checkbox = $("#tbMainDefault tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var id = $.trim(tr.children("td:nth-child(1)").find(".id").val());

            //var seq = $.trim(tr.children("td:nth-child(1)").find(".seq").val());
            var seq = 28;
            //---- Select Inpection
            $.ajax({
                url: 'Services/DefaultService.asmx/SelectInpectionBySeq',
                data: JSON.stringify({
                    id: parseInt(seq)
                }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    //alert("dataaaaaaaaaaa>>>>" + data.d.INSPECTION)
                    var rs = data.d;
                    // if (rs > 0) {
                    if (rs.INSPECTION == 'O') {

                        $('#chkinpection').prop('checked', true);
                    } else {

                        $('#chkinpection').prop('checked', false);
                    }

                    $('#InpectionDate').val(rs.INSPECTION_DATE);
                    $('#Inpector').val(rs.INSPECTOR);
                    $('#InpectionResult').val(rs.RESULT);
                    // }
                    // return false;
                },

            });
            //-----
            var Zone = tr.children("td:nth-child(2)").text();
            var Location = tr.children("td:nth-child(3)").text();
            var QCode = tr.children("td:nth-child(4)").text();
            var Item = $.trim(tr.children("td:nth-child(5)").text());
            var Spec = tr.children("td:nth-child(6)").text();
            var Unit = tr.children("td:nth-child(7)").text();
            var Qty = tr.children("td:nth-child(8)").text();
            var Price = tr.children("td:nth-child(9)").text();
            var Remark = tr.children("td:nth-child(12)").text();
            var Pur_Date = tr.children("td:nth-child(10)").text();
            var locator = tr.children("td:last").text();
            //var Supplier = tr.children("td:nth-child(12)").text();
            //var Buyer = tr.children("td:nth-child(13)").text();
            //var Receiver = tr.children("td:nth-child(14)").text();
            $('#hdqcode').val(QCode);
            $('#action').val(1);
            $("#QCode").val(QCode);
            $("#Zone").val(Zone);
            $('#Location').val(Location);
            $('#Item').val(Item);
            $('#Spec').val(Spec);
            $('#Unit').val(Unit);
            $('#Qty').val(Qty);
            $('#Price').val(Price);
            $('#Remark').val(Remark);
            $('#txtPur_Date').val(Pur_Date);
            $('#hdId').val(id);
            $("#txtLocator").val(locator);
            $('#title').html('<span class="glyphicon glyphicon-edit"></span>Modify Material');
            // $("#btnupdate").removeAttr('disabled');
            $('#Qty').attr('disabled', 'disabled');
            $('#Price').attr('disabled', 'disabled');
            $('#txtPO').attr('disabled', 'disabled');
            $('#txtPur_Date').attr('disabled', 'disabled');
            $("#txtSupplier").attr('disabled', 'disabled');
            $("#txtBuyer").attr('disabled', 'disabled');
            $("#txtReceiver").attr('disabled', 'disabled');
            $("#txtLocator").attr('disabled', 'disabled');
            // alert("dvbarcode");
            $('#txtnguoinhan').val("");
            $("#dvLine").hide();
            $('#dvbarcode').empty();
            $('#mdModify').modal({ backdrop: 'static', keyboard: false });
        }
        else {
            bootbox.alert('Please select an item');
        }
        return false;
    });

    $('#frmModify').submit(function (event) {
        event.preventDefault();
        var action = $('#action').val();
        var ID = $.trim($('#hdId').val());
        var QCode = $.trim($('#QCode').val());
        var Zone = $.trim($('#Zone option:selected').text());
        var Location = $.trim($('#Location').val());
        var Item = $.trim($('#Item').val());
        var Spec = $.trim($('#Spec').val());
        var Unit = $.trim($('#Unit').val());
        var Qty = $.trim($('#Qty').val()).replace(",", ".");
        var Price = $('#Price').val().replace(",", ".");
        var Remark = $.trim($('#Remark').val());
        var Pur_Date = $.trim($('#txtPur_Date').val()).replace("-", "").replace("-", "");
        //----Thanh edit            
        if ($('input[name="chkinpection"]').is(':checked')) {

            var chk_Inpection = 'O';
        } else {

            var chk_Inpection = 'X';
        }
        var Inpection_date = $.trim($('#InpectionDate').val()).replace("-", "").replace("-", "");
        var txtInpector = $.trim($('#Inpector').val());
        var txtResultInpection = $.trim($('#InpectionResult').val());
        //----- End Edit
        var Po = $.trim($('#txtPO').val());
        var Get = "";
        var OldQcode = $.trim($('#hdQcode').val());
        var locator = $.trim($('#txtLocator').val());
        if ($('input[name="chknhan"]').is(':checked')) {
            Get = "1";
        } else {
            Get = "0";
        }
        if (isNaN(Price)) {
            // alert(txtPrice);
            alert("Giá phải là số!");
            $('#Price').focus();
            return false;
        }
        else
            if (isNaN(Qty)) {
                $('#Qty').focus();
                alert("Số lượng phải là số!");

                return false;
            }
            else
                if (parseFloat(Qty) <= 0) {
                    alert("Số lượng phải lớn hơn 0!");
                    $('#Qty').focus();
                    return false;
                }
                else
                    if (Pur_Date == "") {
                        alert("Bạn chưa nhập ngày nhập hàng!");
                        $('#txtPur_Date').focus();
                        return false;
                    }
                    else if (Zone == "") {
                        alert("Bạn chưa nhập khu vực!");
                        $('#Zone').focus();
                        return false;
                    }

        if (action == 0) {

            var Supplier = $.trim($('#txtSupplier').val());
            var Buyer = $.trim($('#txtBuyer').val());
            var Receiver = $.trim($('#txtReceiver').val());
            if (Receiver == "Others") {
                Receiver = $.trim($('#txtnguoinhan').val());
            }
            // insert
            $.ajax({
                url: 'Services/DefaultService.asmx/Insert',
                data: JSON.stringify({
                    QCode: QCode, Zone: Zone, Location: Location, Item: Item, Spec: Spec, Unit: Unit, Price: Price, Po: Po, Qty: Qty, Remark: Remark, Pur_Date: Pur_Date, Supplier: Supplier, Buyer: Buyer, Receiver: Receiver, Get: Get, locator: locator, chkInpection: chk_Inpection, Inpector: txtInpector, Inpecdate: Inpection_date, Resultinpection: txtResultInpection
                }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    if (rs > 0) {
                        bootbox.alert("Insert " + status);
                        //  window.location.reload(true);
                        table.ajax.reload(null, false);
                        $('#mdModify').modal('hide');
                        $('#frmModify')[0].reset();
                    }
                    return false;
                },
                error: function (xhr, status, error) {
                    bootbox.alert("Error!" + xhr.status);
                },
            });
        }
        else {
            //update
            var checkbox = $("#tbMainDefault tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var seq = $.trim(tr.children("td:nth-child(1)").find(".seq").val());

            $.ajax({
                url: 'Services/DefaultService.asmx/Update',
                data: JSON.stringify({
                    ID: ID, QCode: QCode, Zone: Zone, Location: Location, Item: Item, Spec: Spec, Unit: Unit, Qty: Qty, Price: Price, Remark: Remark, Pur_Date: Pur_Date, chkInpection: chk_Inpection,
                    Inpector: txtInpector, Inpecdate: Inpection_date, Resultinpection: txtResultInpection, Seq: seq
                }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    if (rs > 0) {
                        bootbox.alert("Update " + status);
                        $('#mdModify').modal('hide');

                        $('#frmModify')[0].reset();
                        table.ajax.reload(null, false);
                        // window.location.reload(true);
                    }
                    else {
                        bootbox.alert("Qcode: " + QCode + " đã có trong kho rồi! ");
                    }
                    return false;
                },
                error: function (xhr, status, error) {
                    bootbox.alert("Error!" + xhr.status + error);
                    console.log(error);
                    return false;
                },
            });
        }
    });
    $("#btnDelete").click(function () {
        if ($("#tbMainDefault input:checkbox:checked").length > 0) {
            bootbox.confirm("Are you sure you want to delete this item?", function (t) {
                if (t) {
                    var checkbox = $("#tbMainDefault tr").find("input[type='checkbox']:checked");
                    var tr = checkbox.parents().parent();
                    var ID = $.trim(tr.children("td:nth-child(1)").find(".id").val());
                    $.ajax({
                        url: 'Services/DefaultService.asmx/Delete',
                        data: JSON.stringify({
                            ID: ID
                        }),
                        type: 'POST',
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        crossBrowser: true,
                        success: function (data, status) {
                            var rs = data.d;
                            if (rs > 0) {
                                bootbox.alert("Delete " + status);
                                // window.location.reload(true);
                                table.ajax.reload(null, false);
                            }
                            return false;
                        },
                        error: function (xhr, status, error) {
                            bootbox.alert("Error!" + xhr.status);
                        },
                    });
                }
            });
        }
        else {
            bootbox.alert('Please select an item');
        }
        return false;
    });
    //$("#btnUpload").click(function (evt) {
    //    var fileUpload = $("#fupload").get(0);
    //    var files = fileUpload.files;
    //    if (typeof FormData == "undefined") {
    //        alert("IE9 not supported, you should to run this web on firefox or chrome browser!");
    //    }
    //    else {
    //        var data = new FormData();
    //        var ID = $.trim($('#hdId').val());
    //        alert(ID);
    //        var QCode = $.trim($('#QCode').val());
    //        for (var i = 0; i < files.length; i++) {
    //            data.append(files[i].name, files[i]);
    //            data.append("ID", ID);
    //            data.append("QCode", QCode);
    //        }
    //        var options = {};
    //        options.url = "FileUploadHandler.ashx";
    //        options.type = "POST";
    //        options.data = data;
    //        options.contentType = false;
    //        options.processData = false;
    //        options.beforeSend = function () {
    //            //  $("#progress").show();
    //        };
    //        options.success = function (result) {
    //            alert(result);
    //            //var url = window.location.href;
    //            //window.location.href = url;
    //            //return false;
    //            window.location.reload(true);
    //        };
    //        options.error = function (err) { alert(err.statusText); };
    //        options.complete = function () {
    //            //  $("#progress").hide();
    //            $("#fupload").val("");
    //        }
    //        $.ajax(options);
    //        evt.preventDefault();
    //    }
    //});

    $('a[data-toggle="tooltip"]').tooltip({
        animated: 'fade',
        placement: 'bottom',
        html: true
    });
    //$('a[rel=popover]').popover({
    //    html: true,
    //    trigger: 'hover',
    //    placement: 'left',
    //    content: function () { return '<img src="' + $(this).data('img') + '" />'; }
    //});

});
$(document).ajaxComplete(function () {
    FindValueDuplicate();
    $('a[data-toggle="tooltip"]').tooltip({
        animated: 'fade',
        placement: 'bottom',
        html: true
    });
});
function FindValueDuplicate() {
    var table = document.getElementById('tbMainDefault');
    var rows = table.rows, rowcount = rows.length, r,
       cells, cellcount, c, cell;
    for (var i = 1; i < rowcount; i++) {
        var value = rows[i].cells[3].innerHTML.trim();
        for (var r = i + 1; r < rowcount; r++) {
            var value2 = rows[r].cells[3].innerHTML.trim();
            if (value == value2) {
                rows[i].cells[3].bgColor = "yellow";
                rows[r].cells[3].bgColor = "yellow";
            }
        }

    }
}
function loadLine() {
    $.ajax({
        type: "POST",
        url: "Services/DefaultService.asmx/LoadLine",
        data: JSON.stringify({

        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status, xhr) {
            var file = data.d;
            $('#selfile').empty();
            if (file.length > 0) {
                $.each(file, function (index, f) {
                    //$("#lstfile").val(jQuery.trim(f));
                    // $('#selfile').val((jQuery.trim(f)));
                    $('#selfile').append('<option >' + f + '</option>');
                    // alert(f);
                });
            }
            // alert("load file");
            //   window.location.reload();
        },
        error: function (request, status, error) {
            alert("loiiiiiiiiiiiiiiii");
        }
    });
}

$(function () {
    $('[id*=txtSupplier]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/GetSupplier',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.split('-')[1];
                        var name = item.split('-')[0];
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                    $(".dropdown-menu").css("height", "auto");
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=txtSupplier]').val(map[item].id);
            return item;
        }
    });
});
$(function () {
    $('[id*=Zone]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/GetZone',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.split('-')[1];
                        var name = item.split('-')[0];
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                    $(".dropdown-menu").css("height", "auto");
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=Zone]').val(map[item].id);
            return item;
        }
    });
});
$(function () {
    $('[id*=Location]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/GetLocation',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.split('-')[1];
                        var name = item.split('-')[0];
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                    $(".dropdown-menu").css("height", "auto");
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=Location]').val(map[item].id);
            return item;
        }
    });
});
$(function () {
    $('[id*=Unit]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/GetUnit',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.split('-')[1];
                        var name = item.split('-')[0];
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                    $(".dropdown-menu").css("height", "auto");
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=Unit]').val(map[item].id);
            return item;
        }
    });
});

$(function () {
    $('[id*=txtImp_Supplier]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/GetSupplier',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.split('-')[1];
                        var name = item.split('-')[0];
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                    $(".dropdown-menu").css("height", "auto");
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=txtImp_Supplier]').val(map[item].id);
            return item;
        }
    });
});
$(function () {
    $('[id*=txtLocator]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/Getlocator',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.split('-')[1];
                        var name = item.split('-')[0];
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                    $(".dropdown-menu").css("height", "auto");
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=txtLocator]').val(map[item].id);
            return item;
        }
    });
});
$(function () {
    $('[id*=QCode]').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
        , source: function (request, response) {

            $.ajax({
                url: 'Services/DefaultService.asmx/ItemAndSpec',
                data: JSON.stringify({
                    prefix: request
                }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data.d)
                    $("#Spec").val(data.d.Spec);
                    $("#Item").val(data.d.Item);
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });
        },
        updater: function (item) {
            $('[id*=txtLocator]').val(map[item].id);
            return item;
        }
    });
});