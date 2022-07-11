package com.company;

public class control {

    private final int id;
    private final String nom;

    public control(int id,String nom){
        this.id = id;
        this.nom = nom;
    }

    public String getDetails(){
        return "El empleat: " + id + " te el nom: " + nom;
    }
}
