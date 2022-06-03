$(document).ready(function () {
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
    $('#txtImpDate')
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
            url: "../Paging/DefaultPage.aspx/Data",
            data: function (d) {
                return JSON.stringify({ parameters: d, query: $('#hdQuery').val() });
            }
        }
        //
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
    $("#selLine").on('change', function () {
        var value = $.trim($('#selLine').val());
        $("#dvcode").hide();
        if (value == "FACTORY #1" || value == "FACTORY #2" || value == "WORK-COMMON")
        {
            $("#dvcode").show();
        }
    });
    $("#dvother").hide();
    $("#txtCostAcount").on('change', function () {
        var value = $.trim($('#txtCostAcount').val());
    
        $("#dvother").hide();
        if (value == "Others") {
            $("#dvother").show();
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
                url: '../../Services/DefaultService.asmx/GenerateBarcode',
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
                $('#dvbarcode').prepend('<a href="../FileUploadHandler.ashx?file='+Qcode+'"><img id="theImg" src="../BarCode/' + Qcode + '.png"/></a>');
            });;
        } else
            if (txtQcode == "") {
                alert("Please enter Qcode!");
                return false;
            } else
                if (Pur_Date == "") {
                    alert("Please enter import date!");
                    return false;
                }
    });
    
    
    $('#btnAdd').click(function () {
        // alert("ADD");
        $('#frmModify')[0].reset();
        $('#action').val(0);
        $('#Price').text(0);
        $('#Total').text(0);
        $('#title').html('<span class="glyphicon glyphicon-file"></span>Import Material');
        var nowdate = $.trim($('#txtNow').val());
        $("#txtPO").val("");
        $('#txtPur_Date').val(nowdate);
        $('#Qty').removeAttr('disabled');
        $('#Price').removeAttr('disabled');
        $('#txtPur_Date').removeAttr('disabled');
        $("#txtSupplier").removeAttr('disabled');
        $("#txtBuyer").removeAttr('disabled');
        $("#txtReceiver").removeAttr('disabled');
        $("#txtPO").removeAttr('disabled');
        $('#chknhan').prop('checked', false);
        $('#dvbarcode').empty();
        $('#mdModify').modal();
        return false;
    });
    $('#dvlogout').click(function () {
        $.ajax({
            url: '../../Services/DefaultService.asmx/LogOut',
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
            alert(QCode);
            var Pur_Date = tr.children("td:nth-child(10)").text();
            var Qty = tr.children("td:nth-child(8)").text();
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
            $('#modalAllocate').modal();
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
            var Pur_Date = tr.children("td:nth-child(11)").text();
            var nowdate = $('#txtNow').val();
            $('#hdimportdate').val(Pur_Date);
            $('#txtImp_QCode').val(QCode);
            $("#txtImp_QCode").attr('disabled', 'disabled');
            $('#txtImpDate').val(nowdate);
            $('#txtQty').val("");
            $('#txtPrice').val("");
            $('#txtImp_Supplier').val("");
            $('#txtImp_Buyer').val("");
            $('#chknhan2').prop('checked', false);
            $('#modalImport').modal();
        }
    });
    //import save data
    $("#btnImpSave").click(function () {
        var QCode = $.trim($('#txtImp_QCode').val());
        var Imp_date = $.trim($('#txtImpDate').val()).replace("-","").replace("-","");
        var out_date = $.trim($('#txtExportDate').val());
        var txtQty = $.trim($('#txtQty').val());
        var txtPrice = $.trim($('#txtPrice').val()).replace(",",".");
        var txtImp_Supplier = $.trim($('#txtImp_Supplier').val());
        var txtImp_Buyer = $.trim($('#txtImp_Buyer').val());
        var txtImp_Receiver = $.trim($('#txtImp_Receiver').val());
        if (txtImp_Receiver == "Others")
        {
            txtImp_Receiver = $.trim($('#txtImpNhan').val());
        }
        var Po = $.trim($('#txtPo').val());
        var Get = "";
        if ($('input[name="chknhan2"]').is(':checked')) {
            Get = "1";
        } else {
            Get = "0";
        }
       // alert(Get);
        if (parseInt(txtQty) <= 0) {
            alert("Quantity must bigger than 0!");
            return false;
        }
        else
            if (txtPrice == "")
            {
                alert("Please enter price!");
                return false;
            }
            else
                if (isNaN(txtPrice)) {
                   // alert(txtPrice);
                    alert("Price must be number!");
                    return false;
                }
            else
                if (Imp_date == "")
                {
                    alert("Enter date!");
                    return false;
                }
                else {

                    $.ajax({
                        url: '../../Services/DefaultService.asmx/ImportMaterial',
                        data: JSON.stringify({
                            QCode: QCode, Imp_date: Imp_date, txtQty: txtQty, txtPrice: txtPrice,Po:Po, txtImp_Supplier: txtImp_Supplier, txtImp_Buyer: txtImp_Buyer, txtImp_Receiver: txtImp_Receiver,Get:Get
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
        var txtQuantity = $.trim($('#txtQuantity').val());
        var txtRequestor = $.trim($('#txtRequestor').val());
        var hQty = $.trim($('#hdQuantity').val());
        var txtInvenQty = $.trim($('#txtInvenQty').val());
        var txtCostAcount = $.trim($('#txtCostAcount').val());
        var txtRemark = $.trim($('#txtRemark').val());
        var txtCodeCenter = "";
        if (txtLine == "FACTORY #1" || txtLine == "FACTORY #2" || txtLine == "WORK-COMMON")
        {
            txtCodeCenter = $.trim($('#txtCodeArea').val());
        }
        if (txtCostAcount == "Others")
        {
            txtCostAcount = $.trim($('#txtother').val());
        }
        if (parseInt(txtQuantity) > parseInt(txtInvenQty)) {
            alert("Real quantity > stock quantity!");
            return false;
        }
        else if (txtLine == "")
        {
            alert("Please select line!");
            return false;
        }
        else
            if (txtCostAcount == "")
            {
                alert("Please enter code account!");
                return false;
            }
            else
               if (out_date == "")
                {
                    alert("Enter export date");
                    return false;
                }
                else 
                    if ((txtLine == "FACTORY #1" || txtLine == "FACTORY #2" || txtLine == "WORK-COMMON") && txtCodeCenter == "") {
                        alert("Please enter Code Center");
                        return false;
                    }
                 else{
                    $.ajax({
                        url: '../Services/DefaultService.asmx/OutPut',
                        data: JSON.stringify({
                            //  public int OutPut(string QCode,string import_date, string  out_date,string txtLine,string txtQuantity,string txtRequestor,string hQty)
                            QCode: QCode, import_date: import_date, out_date: out_date, txtLine: txtLine, txtInvenQty: txtInvenQty, txtQuantity: txtQuantity, txtCostAcount: txtCostAcount, txtRequestor: txtRequestor, txtRemark: txtRemark, txtCodeCenter: txtCodeCenter
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

                 
                                table.ajax.reload(null, false);
              
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
            var Zone = tr.children("td:nth-child(2)").text();
            var Location = tr.children("td:nth-child(3)").text();
            var QCode = tr.children("td:nth-child(4)").text();
            var Item = $.trim(tr.children("td:nth-child(5)").text());
            var Spec = tr.children("td:nth-child(6)").text();
            var Unit = tr.children("td:nth-child(7)").text();
            var Qty = tr.children("td:nth-child(8)").text();
            var Price = tr.children("td:nth-child(9)").text();
            var Remark = tr.children("td:nth-child(11)").text();
            var Pur_Date = tr.children("td:nth-child(10)").text();
           

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
            $('#title').html('<span class="glyphicon glyphicon-edit"></span>Modify Material');
   
            $('#Qty').attr('disabled', 'disabled');
            $('#Price').attr('disabled', 'disabled');
            $('#txtPO').attr('disabled', 'disabled');
            $('#txtPur_Date').attr('disabled', 'disabled');
            $("#txtSupplier").attr('disabled', 'disabled');
            $("#txtBuyer").attr('disabled', 'disabled');
            $("#txtReceiver").attr('disabled', 'disabled');
  
            $('#txtnguoinhan').val("");
            $("#dvLine").hide();
            $('#dvbarcode').empty();
            $('#mdModify').modal();
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
        var Zone = $.trim($('#Zone').val());
        var Location = $.trim($('#Location').val());
        var Item = $.trim($('#Item').val());
        var Spec = $.trim($('#Spec').val());
        var Unit = $.trim($('#Unit').val());
        var Qty = $.trim($('#Qty').val());
        var Price =$('#Price').val().replace(",",".");
        var Remark = $.trim($('#Remark').val());
        var Pur_Date = $.trim($('#txtPur_Date').val()).replace("-", "").replace("-", "");
        var Po = $.trim($('#txtPO').val());
        var Get = "";
        if ($('input[name="chknhan"]').is(':checked')) {
            Get = "1";
        } else {
            Get = "0";
        }

        if (isNaN(Price)) {
            // alert(txtPrice);
            alert("Giá phải là số!");
            return false;
        }
        else
            if (parseInt(Qty) <= 0)
            {
                alert("Quantity > 0!");
                return false;
            }
            else
                if (Pur_Date == "") {
                    alert("Enter purchase date!");
                    return false;
                }
                else if(Zone=="") {
                    alert("Enter zone!");
                    return false;
                }
                else if (Location == "") {
                    alert("Enter location!");
                    return false;
                }
        
        if (action == 0) {
       
            var Supplier = $.trim($('#txtSupplier').val());
            var Buyer = $.trim($('#txtBuyer').val());
            var Receiver = $.trim($('#txtReceiver').val());
            if (Receiver == "Others")
            {
                Receiver = $.trim($('#txtnguoinhan').val());
            }
            // insert
            $.ajax({
                url: '../Services/DefaultService.asmx/Insert',
                data: JSON.stringify({
                    QCode: QCode, Zone: Zone, Location: Location, Item: Item, Spec: Spec, Unit: Unit, Price: Price,Po:Po, Qty: Qty, Remark: Remark, Pur_Date: Pur_Date, Supplier: Supplier, Buyer: Buyer, Receiver: Receiver,Get:Get
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
            $.ajax({
                url: '../Services/DefaultService.asmx/Update',
                data: JSON.stringify({
                    ID: ID, QCode: QCode, Zone: Zone, Location: Location, Item: Item, Spec: Spec, Unit: Unit, Qty: Qty, Price: Price, Remark: Remark, Pur_Date: Pur_Date
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
                    return false;
                },
                error: function (xhr, status, error) {
                    bootbox.alert("Error!" + xhr.status + error);
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
                        url: '../Services/DefaultService.asmx/Delete',
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
    

    $('a[data-toggle="tooltip"]').tooltip({
        animated: 'fade',
        placement: 'bottom',
        html: true
    });


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
        url: "../Services/DefaultService.asmx/LoadLine",
        data: JSON.stringify({
            
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status, xhr) {
            var file = data.d;
            $('#selfile').empty();
            if (file.length > 0) {
                $.each(file, function (index, f) {
                   
                    $('#selfile').append('<option >' + f + '</option>');
                   
                });
            }
           
        },
        error: function (request, status, error) {
            alert("loiiiiiiiiiiiiiiii");
        }
    });
}

