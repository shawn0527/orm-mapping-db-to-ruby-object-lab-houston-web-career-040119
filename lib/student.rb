require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student

  end

  def self.all
    all = DB[:conn].execute('SELECT * FROM students')
    all.map do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)

    row = DB[:conn].execute('SELECT * FROM students WHERE name = ?', name).flatten
    self.new_from_db(row)
    #
    # binding.pry
    # 0
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    DB[:conn].execute('SELECT * FROM students WHERE grade = 9')
  end

  def self.students_below_12th_grade
    row = DB[:conn].execute('SELECT * FROM students WHERE grade < 12')
    self.new_from_db(row.flatten)
    row

    binding.pry
  end





  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
