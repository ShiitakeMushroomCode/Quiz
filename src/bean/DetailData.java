package bean;

import java.io.Serializable;

public class DetailData implements Serializable {
    private String title;
    private String id;
    private String n1;
    private String n2;
    private String n3;
    private String n4;
    private String exp;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getN1() {
        return n1;
    }

    public void setN1(String n1) {
        this.n1 = n1;
    }

    public String getN2() {
        return n2;
    }

    public void setN2(String n2) {
        this.n2 = n2;
    }

    public String getN3() {
        return n3;
    }

    public void setN3(String n3) {
        this.n3 = n3;
    }

    public String getN4() {
        return n4;
    }

    public void setN4(String n4) {
        this.n4 = n4;
    }

    public String getExp() {
        return exp;
    }

    public void setExp(String exp) {
        this.exp = exp;
    }
}
