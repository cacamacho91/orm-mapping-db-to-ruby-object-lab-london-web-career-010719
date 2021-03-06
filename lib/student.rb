class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    id, name, grade = row
    new_student = self.new
    new_student.id = id
    new_student.name = name
    new_student.grade = grade
    new_student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map do |row|
      new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      new_from_db(row)
    end.first
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
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL
    DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = "10"
      LIMIT ?
    SQL
    DB[:conn].execute(sql, limit).map { |row| new_from_db(row) }
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql, grade).map do |row|
      new_from_db(row)
    end
  end
end
