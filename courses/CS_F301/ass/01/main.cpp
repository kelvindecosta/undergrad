// Aim
// Read data from the text files and output the following
//      List of employees [id, salary]
//      List of teaching assistants [id, name]
//      List of students who aren't teaching assistants [id, name]
//      List of students [id, name, fees, courses]
//
// Print output to terminal and store it in a file
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <map>
#include <vector>
#include <fstream>
#include <ctime>

using namespace std;

string getLocalTime()
{
    time_t t = time(0); // get time now
    tm *now = localtime(&t);
    int year = now->tm_year + 1900;
    int month = now->tm_mon + 1;
    int day = now->tm_mday;
    int hour = now->tm_hour;
    int minute = now->tm_min;
    int second = now->tm_sec;
    stringstream buffer;
    buffer << setfill('0') << setw(2) << hour << ":";
    buffer << setfill('0') << setw(2) << minute << ":";
    buffer << setfill('0') << setw(2) << second;
    buffer << " " << setfill('0') << setw(2) << day;
    buffer << "-" << setfill('0') << setw(2) << month;
    buffer << "-" << setfill('0') << setw(2) << year;
    return buffer.str();
}

class Person
{
    string id;
    string name;

public:
    Person() {}
    Person(string id, string name)
    {
        this->id = id;
        this->name = name;
    }

    string getID()
    {
        return this->id;
    }

    string getName()
    {
        return this->name;
    }
};

class Employee : public Person
{
    string id;
    string name;
    float salary;

public:
    static map<string, Employee> list;

    Employee() {}
    Employee(string id, string name, float salary) : Person(id, name)
    {
        this->salary = salary;
        Employee::list.insert(pair<string, Employee>(id, *this));
    }

    static Employee getByID(string id)
    {
        return Employee::list[id];
    }

    static void listdata(fstream &fout)
    {
        map<string, Employee>::iterator i;
        stringstream buffer;
        buffer << setw(24) << "EMPLOYEE LIST";
        buffer << setw(12) << "\n";
        buffer << setw(6) << std::left << "ID";
        buffer << setw(20) << std::left << "NAME";
        buffer << setw(10) << std::left << "SALARY";
        buffer << endl;

        for (i = list.begin(); i != list.end(); i++)
        {
            buffer << i->second.toString() << endl;
        }
        buffer << endl
               << endl;

        cout << buffer.str();
        fout << buffer.str();
    }

    string toString()
    {
        stringstream buffer;
        buffer << setw(6) << std::left << this->getID();
        buffer << setw(20) << std::left << this->getName();
        buffer << setw(10) << std::left << this->salary;
        return buffer.str();
    }

    float getSalary()
    {
        return this->salary;
    }
};
map<string, Employee> Employee::list;

class Instructor : public Employee
{
protected:
    vector<string> teachingCourses;

public:
    static map<string, Instructor> list;
    Instructor() {}
    Instructor(string id, string name, float salary) : Employee(id, name, salary)
    {
        list.insert(pair<string, Instructor>(id, *this));
    }

    static void assignCourse(string id, string course)
    {
        Instructor::list[id].teachingCourses.push_back(course);
    }

    string getteachingCourses()
    {
        vector<string>::iterator i;
        stringstream buffer;
        for (i = this->teachingCourses.begin(); i != this->teachingCourses.end(); i++)
        {
            buffer << *i;
            if (i + 1 != this->teachingCourses.end())
            {
                buffer << ", ";
            }
        }

        return buffer.str();
    }

    static Instructor getByID(string id)
    {
        return Instructor::list[id];
    }

    static void listdata(fstream &fout)
    {
        map<string, Instructor>::iterator i;
        stringstream buffer;
        buffer << setw(24) << "INSTRUCTOR LIST";
        buffer << setw(12) << "\n";
        buffer << setw(6) << std::left << "ID";
        buffer << setw(20) << std::left << "NAME";
        buffer << setw(60) << std::left << "COURSES";
        buffer << endl;

        for (i = list.begin(); i != list.end(); i++)
        {
            buffer << i->second.toString() << endl;
        }
        buffer << endl
               << endl;
        fout << buffer.str();
        cout << buffer.str();
    }

    string toString()
    {
        stringstream buffer;
        buffer << setw(6) << std::left << this->getID();
        buffer << setw(20) << std::left << this->getName();
        buffer << setw(10) << std::left << this->getteachingCourses();
        return buffer.str();
    }
};
map<string, Instructor> Instructor::list;

class Student : public Person
{
    float fees;

protected:
    vector<string> learningCourses;

public:
    static map<string, Student> list;
    Student() {}
    Student(string id, string name, float fees) : Person(id, name)
    {
        this->fees = fees;
        list.insert(pair<string, Student>(id, *this));
    }

    static void listdata(fstream &fout)
    {
        map<string, Student>::iterator i;
        stringstream buffer;
        buffer << setw(24) << "STUDENT LIST";
        buffer << setw(12) << "\n";
        buffer << setw(6) << std::left << "ID";
        buffer << setw(20) << std::left << "NAME";
        buffer << setw(10) << std::left << "FEES";
        buffer << setw(60) << std::left << "COURSES";
        buffer << endl;

        for (i = list.begin(); i != list.end(); i++)
        {
            buffer << i->second.toString() << endl;
        }
        buffer << endl
               << endl;

        cout << buffer.str();
        fout << buffer.str();
    }

    static void takeCourse(string id, string course)
    {
        Student::list[id].learningCourses.push_back(course);
    }

    string toString()
    {
        stringstream buffer;
        buffer << setw(6) << std::left << this->getID();
        buffer << setw(20) << std::left << this->getName();
        buffer << setw(10) << std::left << this->fees;
        buffer << setw(10) << std::left << this->getlearningCourses();
        return buffer.str();
    }

    string getlearningCourses()
    {
        vector<string>::iterator i;
        stringstream buffer;
        for (i = this->learningCourses.begin(); i != this->learningCourses.end(); i++)
        {
            buffer << *i;
            if (i + 1 != this->learningCourses.end())
            {
                buffer << ", ";
            }
        }

        return buffer.str();
    }

    static void setFees(string id, float fees)
    {
        Student::list[id].fees = fees;
    }
};
map<string, Student> Student::list;

class TeachingAssistant : public Student, public Instructor
{
public:
    static map<string, TeachingAssistant> list;
    TeachingAssistant() {}
    TeachingAssistant(string id, string name, float fees, float salary) : Student(id, name, fees), Instructor(id, name, salary)
    {
        list.insert(pair<string, TeachingAssistant>(id, *this));
    }

    static void assignCourse(string id, string course)
    {
        Instructor::assignCourse(id, course);
        TeachingAssistant::list[id].teachingCourses.push_back(course);
    }

    static void takeCourse(string id, string course)
    {
        Student::takeCourse(id, course);
        TeachingAssistant::list[id].learningCourses.push_back(course);
    }

    static void setFees(string id, float fees)
    {
        Student::setFees(id, fees);
    }
};
map<string, TeachingAssistant> TeachingAssistant::list;

void listdata_not_ta(fstream &fout)
{
    map<string, Student>::iterator i;
    stringstream buffer;
    buffer << setw(32) << "STUDENTS (NOT INSTRUCTORS)";
    buffer << setw(12) << "\n";
    buffer << setw(6) << std::left << "ID";
    buffer << setw(20) << std::left << "NAME";
    buffer << setw(10) << std::left << "FEES";
    buffer << setw(60) << std::left << "COURSES";
    buffer << endl;

    for (i = Student::list.begin(); i != Student::list.end(); i++)
    {
        string test_id = i->first;
        if (TeachingAssistant::list.count(test_id) != 1)
        {
            buffer << i->second.toString() << endl;
        }
    }
    buffer << endl
           << endl;
    fout << buffer.str();
    cout << buffer.str();
}

void listdata_ta(fstream &fout)
{
    map<string, Instructor>::iterator i;
    stringstream buffer;
    buffer << setw(32) << "TEACHING ASSISTANTS";
    buffer << setw(12) << "\n";
    buffer << setw(6) << std::left << "ID";
    buffer << setw(20) << std::left << "NAME";
    buffer << setw(10) << std::left << "FEES";
    buffer << setw(60) << std::left << "COURSES";
    buffer << endl;

    for (i = Instructor::list.begin(); i != Instructor::list.end(); i++)
    {
        string test_id = i->first;
        if (TeachingAssistant::list.count(test_id) == 1)
        {
            buffer << i->second.toString() << endl;
        }
    }
    buffer << endl
           << endl;
    fout << buffer.str();
    cout << buffer.str();
}

void read_employee_data(string filename)
{
    ifstream fin;
    string line;
    fin.open(filename);
    if (fin.fail())
    {
        cerr << "File does not exist!" << endl;
        exit(1);
    }
    while (!fin.eof())
    {
        getline(fin, line, '\n');
        if (fin.eof())
        {
            break;
        }
        string token;
        vector<string> words;
        stringstream ss(line);
        while (getline(ss, token, ','))
        {
            words.push_back(token);
        }
        string id = words[0];
        string name = words[1];
        float salary = stof(words[2]);

        switch (id[0])
        {
        case 'E':
            Instructor(id, name, salary);
            break;
        case 'S':
            TeachingAssistant(id, name, 0, salary);
            break;
        default:
            cout << "Error";
        }
    }
    fin.close();
}

void read_instructor_data(string filename)
{
    ifstream fin;
    string line;
    fin.open(filename);
    if (fin.fail())
    {
        cerr << "File does not exist!" << endl;
        exit(1);
    }
    while (!fin.eof())
    {
        getline(fin, line, '\n');
        if (fin.eof())
        {
            break;
        }
        string token;
        vector<string> words;
        stringstream ss(line);
        while (getline(ss, token, ','))
        {
            words.push_back(token);
        }
        string id = words[0];
        string course = words[1];
        switch (id[0])
        {
        case 'E':
            Instructor::assignCourse(id, course);
            break;
        case 'S':
            TeachingAssistant::assignCourse(id, course);
            break;
        default:
            cout << "Error";
        }
    }
    fin.close();
}

void read_student_data(string filename)
{
    ifstream fin;
    string line;
    fin.open(filename);
    if (fin.fail())
    {
        cerr << "File does not exist!" << endl;
        exit(1);
    }
    while (!fin.eof())
    {
        fin >> line;
        if (fin.eof())
        {
            break;
        }
        string token;
        vector<string> words;
        stringstream ss(line);
        while (getline(ss, token, ','))
        {
            words.push_back(token);
        }
        string id = words[0];
        string name = words[1];
        float fees = stof(words[2]);
        int i;

        if (TeachingAssistant::list.count(id) != 1)
        {
            Student(id, name, fees);
            for (i = 0; i < 3; i++)
            {
                Student::takeCourse(id, words[3 + i]);
            }
        }
        else
        {
            TeachingAssistant::setFees(id, fees);
            for (i = 0; i < 3; i++)
            {
                Student::takeCourse(id, words[3 + i]);
            }
        }
    }
    fin.close();
}

int main(int argc, char *argv[])
{
    read_employee_data(argv[1]);
    read_instructor_data(argv[2]);
    read_student_data(argv[3]);

    fstream fout;
    fout.open(argv[4], fstream::in | fstream::out | fstream::app);
    if (!fout)
    {
        fout.open(argv[4], fstream::in | fstream::out | fstream::trunc);
    }

    fout << "-------------------";
    fout << getLocalTime();
    fout << "-------------------\n";

    Employee::listdata(fout);
    listdata_not_ta(fout);
    listdata_ta(fout);
    Student::listdata(fout);

    fout << "-------------------";
    fout << "-------------------";
    fout << "-------------------\n";
    fout.close();
}
