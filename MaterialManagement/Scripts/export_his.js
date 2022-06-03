$(document).ready(function () {
    $('#txtfrom')
.datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
});
    $('#txtto')
.datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
});
    $('#txtExportDate')
.datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
});
    $('#imgExport').addClass("Addimg");
    //$("#tbContent").on('click', 'tr', function (e) {
    //    if (!$(this).parent("thead").is('thead')) {
    //        $("tr").removeClass("success");
    //        $(this).addClass("success");
    //        if (!$(e.target).is('#tbContent td input:checkbox')) {
    //            $(this).find('input:checkbox').trigger('click');
    //        }
    //    }
    //});
    //$("#tbContent").on('change', '.chk', function () {
    //    var group = ":checkbox[class='" + $(this).attr("class") + "']";
    //    if ($(this).is(':checked')) {
    //        $(group).not($(this)).attr("checked", false);
    //    }
    //});
    $("#tblfinal").on('click', 'tr', function (e) {
        var index = $(this).index();
        if (!$(this).parent("thead").is('thead')) {
            $("tr").removeClass("success");
            $(this).addClass("success");
            tomau2(index);
            if (!$(e.target).is('#tblfinal td input:checkbox'))
                $(this).find('input:checkbox').trigger('click');
        }
    });
    $("#tblfinal").on('change', '.chk', function () {
        var group = ":checkbox[class='" + $(this).attr("class") + "']";
        if ($(this).is(':checked')) {
            $(group).not($(this)).attr("checked", false);
        }
    });
    $("#tblfinal2").on('click', 'tr', function (e) {
        var index = $(this).index();
        tomau1(index);
        $("tr").removeClass("success");
        $('#tblfinal2 tbody tr:eq(' + index + ')').addClass("success");
        $('input:checkbox').removeAttr('checked');
        $('.chk')[index].checked = true;
        if (!$(e.target).is('#tblfinal td input:checkbox'))
            $(this).find('input:checkbox').trigger('click');
    });
    $(".chk").on('change', function () {
        var group = $(".chk");
        if ($(this).is(':checked')) {
            $(group).not($(this)).attr("checked", false);
        }
    });
    $("#dvcode").hide();
    $("#selLine").on('change', function () {
        var value = $.trim($('#selLine').val());
        $("#dvcode").hide();
        if (value == "FACTORY #1" || value == "FACTORY #2" || value == "WORK-COMMON") {
            $("#dvcode").show();
        }
    });
    $("#dvother").hide();
    $("#txtCostAcount").on('change', function () {
        var value = $.trim($('#txtCostAcount').val());
        $("#dvother").hide();
        $("#dvNote").hide();
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
    $('#btnModify').click(function () {
        if ($("#tblfinal input:checkbox:checked").length > 0) {
           // alert("chinh sửa");
            var checkbox = $("#tblfinal tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var Seq = $.trim(tr.children("td:nth-child(1)").find(".id").val());
            $("#hdSeq").val(Seq);
            $.ajax({
                url: 'Services/ExportService.asmx/LoadEX',
                data: JSON.stringify({
                    Seq: Seq
                }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    //alert(rs);
                    if (rs !="") {
                        var d = data.d;
                        var line = d.Line;
                        $("#dvcode").hide();
                     if (line == "FACTORY #1" || line == "FACTORY #2" || line == "WORK-COMMON") {
                         $("#dvcode").show();
                         $('#txtCodeArea').val(d.CodeCenter);
                     }
                     var CostAcount = d.CostAccount;
                   //  alert(CostAcount);
                     if (CostAcount != "602011-0000" && CostAcount != "602021-0000" && CostAcount != "602031-0000" && CostAcount != "602041-0000" && CostAcount != "606191-2802") {
                         $("#dvother").show();
                         $("#dvNote").hide();
                         $("#txtCostAcount").val("Others");
                         $("#txtother").val(CostAcount);
                     }
                     else {
                         $("#dvother").hide();
                         $("#dvNote").show();
                         $("#txtCostAcount").val(d.CostAccount);
                         $("#SelNote").empty();
                         if (CostAcount == "602011-0000") {
                             $("#SelNote").append('<option>--</option> <option>CNG</option> <option>N2</option> <option>NH3</option>');
                         }
                         else
                             if (CostAcount == "602021-0000") {
                                 $("#SelNote").append('<option>--</option> <option>KRAFT PAPER</option> <option>PE FOR APL, STL</option> <option>PAPER SPOOL</option> <option>G/STONE</option> <option>ALKALI</option> <option>ACID-APL</option> <option>WATER TREAT</option> <option>SALT</option> <option>ETC-PRO</option> <option>ROLL</option><option>ROLLING OIL</option><option>BACKUP BEARING</option> <option>ANODE</option><option>OIL FILTER</option>');
                             }
                             else
                                 if (CostAcount == "602031-0000") {
                                     $("#SelNote").append('<option>--</option> <option>OIL</option> <option>BEARING</option> <option>ELECTRIC SPARE</option> <option>MECHANICAL SPARE</option> <option>TOOL</option> <option>ETC-MAINT</option>');
                                 }
                                 else
                                     if (CostAcount == "602041-0000") {
                                         $("#SelNote").append('<option>--</option> <option>PE COVER</option> <option>IN-OUTER RING</option> <option>STEEL BAND</option> <option>WOODEN PALLET</option> <option>WATER PROOF, VINYL, ETC</option>');   
                                     }
                         $("#SelNote").val(d.Note);  
                     }
                     $('#txtInvenQty').attr('disabled', 'disabled');
                     $("#txtCode").attr('disabled', 'disabled');
                     $("#txtImport_Date").attr('disabled', 'disabled');
                        $("#txtCode").val(d.QCode);
                        $("#txtImport_Date").val(d.Pur_Date);
                        $("#txtExportDate").val(d.Out_date);
                        $('#txtInvenQty').val(d.inventory);
                        $("#txtQuantity").val(d.Quantity);
                        $("#selLine").val(d.Line);
                        $("#txtlocator").val(d.locator);
                        $("#txtRequestor").val(d.Requestor);
                        $("#txtRemark").val(d.Remark);
                        // $('#frmModify')[0].reset();
                        //table.ajax.reload(null, false);
                        // window.location.reload(true);
                        $("#modalAllocate").modal();

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
        else {
            alert("Bạn phải chọn 1 dòng để chỉnh sửa!");
            return false;
        }
    });
    $('#btnSave').click(function () {
      
        var QCode = $.trim($("#txtCode").val());
       // var txtImport_Date= $.trim($("#txtImport_Date").val());
        var import_date = $.trim($("#txtImport_Date").val());
        var out_date = $.trim($("#txtExportDate").val());
        var txtInvenQty = $.trim($("#txtInvenQty").val());
        var txtQuantity = $.trim($("#txtQuantity").val()).replace(",",".");
        var txtLine = $.trim($("#selLine").val());
        var txtCostAcount = $.trim($("#txtCostAcount").val());
        var txtRequestor = $.trim($("#txtRequestor").val());
        var txtRemark = $.trim($("#txtRemark").val());
        var locator = $.trim($("#txtlocator").val());
        var txtCodeCenter = "";
        var txtNote = "";
        var Seq = $("#hdSeq").val();
        if (txtLine == "FACTORY #1" || txtLine == "FACTORY #2" || txtLine == "WORK-COMMON") {
            txtCodeCenter = $.trim($('#txtCodeArea').val());
        }
        if (txtCostAcount == "Others") {

            txtCostAcount = $.trim($('#txtother').val());
        }
        else {
            if (txtCostAcount == '602011-0000' || txtCostAcount == '602021-0000' || txtCostAcount == '602031-0000' || txtCostAcount == '602041-0000')
            {
                if ($.trim($("#SelNote").val()) != "--") {
                    txtNote = $.trim($("#SelNote").val());
                }
            }
        }
        //alert(txtQuantity);
        //alert(txtInvenQty);
        //var qtty = parseInt(txtQuantity);
        //var inventory = parseInt(txtInvenQty);
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
        if (parseInt(txtQuantity) > parseInt(txtInvenQty)) {
            alert("Số lượng cấp lớn hơn thực tế trong kho!");
            return false;
        }
        else
            if (out_date == "") {
                alert("Bạn chưa nhập ngày xuất");
                return false;
            }
        else
            if (txtLine == "") {
            alert("Bạn chưa chọn line!");
            return false;
        }
        else
          if (txtCostAcount == "") {
                    alert("Bạn chưa nhập mã kế toán!");
                    return false;
                }
                else   
                    if ((txtLine == "FACTORY #1" || txtLine == "FACTORY #2" || txtLine == "WORK-COMMON") && txtCodeCenter == "")
                    {
                       alert("Bạn chưa nhập mã Code Center");
                       $("#txtCodeArea").focus();
                        return false;
                    }
                    else
               {
                $.ajax({  
                        url: 'Services/ExportService.asmx/UpdateExport',
                        data: JSON.stringify({
                            //  public int OutPut(string QCode,string import_date, string  out_date,string txtLine,string txtQuantity,string txtRequestor,string hQty)
                         Seq:Seq, QCode: QCode, import_date: import_date, out_date: out_date, txtLine: txtLine, txtInvenQty: txtInvenQty, txtQuantity: txtQuantity, txtCostAcount: txtCostAcount, txtRequestor: txtRequestor, txtRemark: txtRemark, txtCodeCenter: txtCodeCenter,txtNote:txtNote,locator:locator
                        }),
                        type: 'POST',
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        crossBrowser: true,
                        success: function (data, status) {
                            var rs = data.d;
                            //alert(rs);
                            if (rs > 0) {
                              //  alert("ok");
                                bootbox.alert("Alocate " + status);
                                $('#modalAllocate').modal('hide');
                                //  $('#frmModify')[0].reset();
                               // table.ajax.reload(null, false);
                                window.location.reload(true);
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
    $("#bntDelete").click(function () {
        alert("bntDelete");
        if ($("#tblfinal input:checkbox:checked").length > 0) {
            var checkbox = $("#tblfinal tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var Seq = $.trim(tr.children("td:nth-child(1)").find(".id").val());
            var Qcode = $.trim(tr.children("td:nth-child(3)").text());
            var confirm1 = confirm("Bạn có muốn xóa dòng nhập có QCode= " + Qcode + " không?");
            if (confirm1) {
                $.ajax({
                    url: 'Services/ExportService.asmx/Delete',
                    data: JSON.stringify({
                        Seq: Seq
                    }),
                    type: 'POST',
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    crossBrowser: true,
                    success: function (data, status) {
                        var rs = data.d;
                        // alert(rs);
                        if (rs > 0) {
                            alert("success!");
                            //  bootbox.alert("Alocate " + status);
                            //  $('#modalImport').modal('hide');
                            //  $('#frmModify')[0].reset();
                            //table.ajax.reload(null, false);
                            window.location.reload(true);
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
        } else {
            alert("Bạn phải chọn 1 dòng để xóa!");
            return false;
        }
    });
});
function resetcolor() {
    var tbl = document.getElementById('tblfinal');
    var tbl2 = document.getElementById('tblfinal2');
    var rowLength = tbl.rows.length;
    for (var r = 0; r < rowLength; r++) {
        var row = tbl.rows[r];
        var row2 = tbl2.rows[r];
        if (row.cells[1].innerHTML == "") {
            row.bgColor = "aquamarine";
            row2.bgColor = "aquamarine";
        }
        else {
            row.bgColor = "white";
            row2.bgColor = "white";
        }
    }
}
function tomau2(id) {
    resetcolor();
    var tbl = document.getElementById('tblfinal2');
    var rowLength = tbl.rows.length;
    tbl.rows[id].bgColor = "#93db9b";
}
function tomau1(id) {
    resetcolor();
    var tbl = document.getElementById('tblfinal');
    var rowLength = tbl.rows.length;
    tbl.rows[id].bgColor = "#93db9b";
}