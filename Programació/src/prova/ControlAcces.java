package prova;
import com.company.control;

class ProvaAcces extends control{

    private final int idDepartament;
    public ProvaAcces(int id, String nom,int idDepartament) {
        super(id, nom);
        this.idDepartament = idDepartament;
    }

    public String getDetails(){
        return super.getDetails() + " Te el departament:" + idDepartament;
    }
}

public class ControlAcces{

    public static void main(String[] args) {

        ProvaAcces x = new ProvaAcces(1,"tomeu",3);
        ProvaAcces y = x;
        System.out.println(x.equals(y));
        ProvaAcces z = new ProvaAcces(1,"tomeu",3);
        System.out.println(x.equals(z));


        /*control comun = new control(1,"tomeu");

        System.out.println(comun.getDetails());
        System.out.println(x.getDetails());*/

    }

}
