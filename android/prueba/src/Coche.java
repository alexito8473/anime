public class Coche {
    int ruedas;
    String color;
    String marca;

    double velocidadMaxima;

    Coche(int ruedas,String color,String marca,double velocidadMaxima){
        this.ruedas=ruedas;
        this.color=color;
        this.marca=marca;
        this.velocidadMaxima=velocidadMaxima;
    }
    public void correr() {
        System.out.println("Runnnnnnnn");
    }
    public void reducir() {
       this.velocidadMaxima=velocidadMaxima-20;
    }
    public void reducir(int velocidad) {
        this.velocidadMaxima=velocidadMaxima-velocidad;
    }
    public void parar() {
        System.out.println("Stopppppppppp");
    }
}
