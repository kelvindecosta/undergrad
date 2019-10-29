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
        
        print(root, 0);
        System.out.println("");
    }
    
    public static void print(Node node, int indent) {
        String output = "\n";
        for (int j = 0; j < indent; j++){
            output += "\t";
        }
        output += node.getNodeName();
        System.out.print(output);
 
        NodeList nodes = node.getChildNodes();
        boolean check = false;
        for (int i = 0; i < nodes.getLength(); i++) {
            Node n = nodes.item(i);
            if (!n.getNodeName().equals("#text")) {
                print(n, indent+1);
                check = true;
            }
        }
        
        if(!check) {
            String content = node.getTextContent();
            if (!content.equals("")) {
                System.out.print(" : " + content);
            }
        }
    }
    
}
