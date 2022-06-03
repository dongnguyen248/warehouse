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
    $('#txtImpDate')
.datepicker({
    format: 'yyyymmdd',
    autoclose: true
});
    $('#imgImport').addClass("Addimg");
    
    $("#tbContent").on('click', 'tr', function (e) {
        if (!$(this).parent("thead").is('thead')) {
            $("tr").removeClass("success");
            $(this).addClass("success");
            if (!$(e.target).is('#tbContent td input:checkbox')) {
                $(this).find('input:checkbox').trigger('click');
            }
        }
    });
    $("#tbContent").on('change', '.chk', function () {
        var group = ":checkbox[class='" + $(this).attr("class") + "']";
        if ($(this).is(':checked')) {
            $(group).not($(this)).attr("checked", false);
        }
    });
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
    $("#btnModify").click(function () {
        //$("#modalImport").modal();
        if ($("#tblfinal input:checkbox:checked").length > 0) {
            var checkbox = $("#tblfinal tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var Seq = $.trim(tr.children("td:nth-child(1)").find(".id").val());
          //  alert(Seq);
          //  var QCode = tr.children("td:nth-child(2)").text();
          //  var ImpDate = tr.children("td:nth-child(4)").text();
          //  var Qty = tr.children("td:nth-child(5)").text();
          //  var Price = tr.children("td:nth-child(6)").text();
          //  var Po = tr.children("td:nth-child(7)").text();
          //  var Supplyer = tr.children("td:nth-child(8)").text();
          //  var Buyer =$.trim(tr.children("td:nth-child(9)").text());
          //  var Receiver = $.trim(tr.children("td:nth-child(10)").text());
           
          //  $("#txtImpDate").val(ImpDate);
          //  $("#txtQty").val(Qty);
          ////  $("#txtImp_QCode").val(Qty);
          //  $("#txtPrice").val(Price);
          //  $("#txtImp_Supplier").val(Supplyer);
          // // alert(Buyer);
          //  $("#txtImp_Buyer").val(Buyer);
          //  $("#txtImp_Receiver").val(Receiver);
            //  $("#txtImp_QCode").val(QCode);
          //  $("#hdSeq").val(Seq);
          //  $("#txtImp_QCode").attr('disabled', 'disabled');
          //  $("#txtImpDate").attr('disabled', 'disabled');
           
            $("#hdSeq").val(Seq);
           // alert($("#hdQCode").val());
            $.ajax({
                url: 'Services/ImportService.asmx/LoadImp',
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
                        var Get = d.Allocated;
                        $("#txtImp_QCode").val(d.QCode);
                        $("#hdQCode").val(d.QCode);
                        $("#hdPur_Date").val(d.Pur_Date);
                        $("#txtImpDate").val(d.Pur_Date);
                        $("#txtPrice").val(d.Price);
                        $("#txtPo").val(d.Po);
                        $("#txtQty").val(d.Quantity);
                        $("#txtImp_Supplier").val(d.Supplier);
                        $("#txtImp_Buyer").val(d.Buyer);
                        $("#txtImp_Receiver").val(d.Receiver);
                        if (Get == "1") {
                            $("#chknhan").prop('checked', true);
                            // $('#myCheckbox').prop('checked', true); /
                        }
                        else {
                            $("#chknhan").prop('checked', false);
                        }
                       // alert(d.Remark);
                        $("#txtRemark").val(d.Remark);
                        if (d.locator == "") {
                            $("#txtlocator").val("QMA01.");
                        } else {
                            $("#txtlocator").val(d.locator);
                        }
                        $("#modalImport").modal();
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
    //import save data
    $("#btnImpSave").click(function () {
        var QCode = $.trim($('#txtImp_QCode').val());
        var Imp_date = $.trim($('#txtImpDate').val()).replace("-", "").replace("-", "");
        //var out_date = $.trim($('#txtExportDate').val());
        var txtQty = $.trim($('#txtQty').val()).replace(",", ".");
        var txtPrice = $.trim($('#txtPrice').val()).replace(",",".");
        var txtImp_Supplier = $.trim($('#txtImp_Supplier').val());
        var txtImp_Buyer = $.trim($('#txtImp_Buyer').val());
        var txtImp_Receiver = $.trim($('#txtImp_Receiver').val());
        var Seq = $.trim($("#hdSeq").val());
        var Po = $.trim($('#txtPo').val());
        var Remark = $.trim($('#txtRemark').val());
        var locator = $.trim($('#txtlocator').val());
        var GET = "";
        if ($('input[name="chknhan"]').is(':checked')) {
            GET = "1";
        } else {
            GET = "0";
        }
        if (txtQty == "")
        {
            alert("Bạn phải nhập số lượng!");
            $('#txtQty').focus();
            return false;
        }
        else
            if (isNaN(txtQty))
            {
                alert("Số lượng phải là số!");
                $('#txtQty').focus();
                return false;
            }
        else
        if ( parseFloat(txtQty) <= 0) {
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
                if (isNaN(txtPrice))
                {
                    alert("Giá phải là số!");
                    $('#txtPrice').focus();
                    return false;
                }
                else
                    if (parseFloat(txtPrice) <= 0)
                    {
                        alert("Giá phải lớn hơn 0!");
                        $('#txtPrice').focus();
                        return false;
                    }
                    else
                        if (Imp_date == "") {
                            alert("Bạn phải nhập ngày nhập hàng!");
                            $('#txtImpDate').focus();
                            return false;
                        }
                        else if (locator == "QMA01." || locator == "")
                        {
                            alert("Bạn phải nhập vị trí(locator)!");
                            $('#txtlocator').focus();
                            return false;
                        }
                        else {
                         //   alert("Modify import");
                            var OldQCode = $.trim($("#hdQCode").val());
                            var OldImp_Date = $.trim($("#hdPur_Date").val());
                            $.ajax({
                               
                                url: 'Services/ImportService.asmx/ModifyImport',
                                data: JSON.stringify({
                                    Seq: Seq, QCode: QCode, Imp_date: Imp_date, txtQty: txtQty, txtPrice: txtPrice, Po: Po, txtImp_Supplier: txtImp_Supplier, txtImp_Buyer: txtImp_Buyer, txtImp_Receiver: txtImp_Receiver, OldQCode: OldQCode, OldImp_Date: OldImp_Date, GET: GET, Remark: Remark, locator: locator
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
        return false;
    });
    $("#btnDelete").click(function () {
        if ($("#tblfinal input:checkbox:checked").length > 0) {
            var checkbox = $("#tblfinal tr").find("input[type='checkbox']:checked");
            var tr = checkbox.parents().parent();
            var Seq = $.trim(tr.children("td:nth-child(1)").find(".id").val());
            var Qcode = $.trim(tr.children("td:nth-child(2)").text());
            var confirm1 = confirm("Bạn có muốn xóa dòng nhập có QCode= " + Qcode + " không?");
            if (confirm1) {
                $.ajax({
                    url: 'Services/ImportService.asmx/Delete',
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