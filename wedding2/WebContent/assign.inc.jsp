<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h1>Assign guests to tables</h1>

<form name="form0">
<table class="form">

    <tr>
        <td>Select guest to assign</td>
        <td><select name="id" id="id">
        </select></td>
    </tr>
    <tr>
        <td>Assign to table</td>
        <td><select name="tableID" id="tableID">
            <option value="0">(unassigned)</option>
        </select></td>
    </tr>

    <tr>
        <td>&nbsp;</td>
        <td><input type="submit" value="Assign" /></td>
    </tr>

</table>
</form>

