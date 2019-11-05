/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kelvin;

import javax.xml.parsers.*;
import org.w3c.dom.*;

public class DOMParser {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
        // TODO code application logic here
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(false);
        
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse("../Contact.xml");
        Element root = doc.getDocumentElement();

        Element age = (Element) root.getElementsByTagName("Age").item(0);
        System.out.print(age.getTagName() + " : ");
        System.out.println(age.getTextContent().trim());
        
        NamedNodeMap attributes = root.getAttributes();
        System.out.println(attributes.getNamedItem("id"));
        System.out.println(attributes.getNamedItem("number"));
    }
}
