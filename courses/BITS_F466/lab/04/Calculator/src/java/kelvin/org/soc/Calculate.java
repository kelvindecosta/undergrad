/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kelvin.org.soc;

import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;

/**
 *
 * @author Admin
 */
@WebService(serviceName = "Calculate")
public class Calculate {

    /**
     * Web service operation
     */
    @WebMethod(operationName = "add")
    public Integer add(@WebParam(name = "operand1") Integer operand1, @WebParam(name = "operand2") Integer operand2) {
        //TODO write your implementation code here:
        return operand1 + operand2;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "subtract")
    public Integer subtract(@WebParam(name = "operand1") Integer operand1, @WebParam(name = "operand2") Integer operand2) {
        //TODO write your implementation code here:
        return operand1 - operand2;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "multiply")
    public Integer multiply(@WebParam(name = "operand1") Integer operand1, @WebParam(name = "operand2") Integer operand2) {
        //TODO write your implementation code here:
        return operand1 * operand2;
    }
  
    /**
     * Web service operation
     */
    @WebMethod(operationName = "divide")
    public Integer divide(@WebParam(name = "operand1") Integer operand1, @WebParam(name = "operand2") Integer operand2) {
        //TODO write your implementation code here:
        return operand1 / operand2;
    }
}
