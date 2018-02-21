package polynomial;

class Polynomial {
    Term head;
    int id;

    public Polynomial(int id) {
        this.id = id;
        this.head = null;
        this.add(0, 0);
    }

    class Term {
        int coeff;
        int degree;
        Term next;

        Term(int coeff, int degree) {
            this.coeff = coeff;
            this.degree = degree;
            this.next = null;
        }

        void addTerm(Term other) {
            this.coeff += other.coeff;
        }

        void subTerm(Term other) {
            this.coeff -= other.coeff;
        }

        void printTerm() {
            if (coeff == 0)
                return;
            if (degree == 1)
                System.out.print(this.coeff + "x ");
            else if (degree != 0)
                System.out.print(this.coeff + "x^" + this.degree + " ");
            else
                System.out.print(this.coeff + " ");
        }
    }

    public void add(Term temp) {
        add(temp.coeff, temp.degree);
    }

    public void add(int coeff, int degree) {
        Term newTerm = new Term(coeff, degree);
        if (isEmpty()) {
            head = newTerm;
            return;
        }

        Term temp = head;
        if (temp.degree < newTerm.degree) {
            newTerm.next = head;
            head = newTerm;
            return;
        } else if (temp.degree == newTerm.degree) {
            temp.addTerm(newTerm);
            return;
        }
        Term prev = temp;
        temp = temp.next;

        while (temp != null) {
            if (temp.degree == newTerm.degree) {
                temp.addTerm(newTerm);
                return;
            } else if (temp.degree < newTerm.degree) {
                newTerm.next = temp;
                prev.next = newTerm;
                return;
            }
            prev = temp;
            temp = temp.next;
        }
        prev.next = newTerm;
        newTerm.next = null;
    }

    public boolean isEmpty() {
        return head == null;
    }

    public void print() {
        Term temp = head;
        System.out.print("P" + id + "(x) = ");
        while (temp != null) {
            temp.printTerm();
            if (temp.next != null)
                if (temp.next.coeff > 0)
                    System.out.print(" + ");
                else if (temp.next.coeff < 0)
                    System.out.print(" ");
            temp = temp.next;
        }
        System.out.println();
    }

    Polynomial addition(Polynomial other) {
        Polynomial answer = new Polynomial(this.id + other.id);
        Term t1 = this.head;
        Term t2 = other.head;

        while (t1 != null && t2 != null) {
            if (t1.degree > t2.degree) {
                answer.add(t1);
                t1 = t1.next;
            } else if (t1.degree == t2.degree) {
                answer.add(t1);
                answer.add(t2);
                t1 = t1.next;
                t2 = t2.next;
            } else {
                answer.add(t2);
                t2 = t2.next;
            }
        }
        while (t1 != null) {
            answer.add(t1);
            t1 = t1.next;
        }
        while (t2 != null) {
            answer.add(t2);
            t2 = t2.next;
        }
        return answer;
    }

    Polynomial subtraction(Polynomial other) {
        Polynomial subtract = new Polynomial(-1 * other.id);
        Term temp = other.head;
        while (temp != null) {
            Term sub = temp;
            sub.coeff *= -1;
            subtract.add(sub);
            temp = temp.next;
        }

        return this.addition(subtract);
    }
}
