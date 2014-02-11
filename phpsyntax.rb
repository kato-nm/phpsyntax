#!/usr/bin/ruby

class ProblemReport
  attr_accessor :lineNo, :line, :message, :marker

  def initialize(lineNo, line, message, marker)
    @lineNo = lineNo
    @line = line
    @message = message
    @marker = marker
  end

  def printReport
    no = @lineNo.to_s
    print @message, "  '", @marker, "'\n"
    print no, ":", @line
    i = @line.index(@marker)
    print " " * (i + no.length + 1) + "^" *  @marker.length, "\n"
    print "\n"
  end

end
 
class ProblemReportCollector

  attr_accessor :reports

  def initialize
    @reports = []
  end

  def addReport(line, report)
    @reports << report
  end

  def printReports
    print "\n-----------------------------------\n"
    for report in @reports do
      report.printReport
    end
  end

end

class MemberAccessChecker
  attr_accessor :regexp, :message

  def initialize(regexp, message)
    @regexp = regexp
    @message = message
  end

  def check(lineNo, line, collector)
    if @regexp =~ line then
      print @message, "\n"
      report = ProblemReport.new(lineNo, line, @message, $1)
      collector.addReport(lineNo, report)
    end
  end

end

class PhpChecker

  attr_accessor :collector, :lineNo, :javaMemberAccess, :dollarMemberAccess
  attr_accessor :staticMemberAccessWithoutDollar, :selfWithDollar

  def initialize
    @lineNo = 1
    @javaMemberAccess = MemberAccessChecker.new(/\$this.*(\.\w+)/,
                                                "Java style member access")
    @dollarMemberAccess = MemberAccessChecker.new(/\$this.*\-\>(\$\w+)/,
                                                  "Member access with '$'")
    @staticMemberAccessWithoutDollar = MemberAccessChecker.new(/self\:\:(\w+)/,
                                                               "Static member access without '$'")
    @selfWithDollar = MemberAccessChecker.new(/(\$self\:\:)/,
                                              "'self' starts with '$'")
  end
 
  def checkIllegalMemberAccess(line)
    @javaMemberAccess.check(@lineNo, line, @collector)
    @dollarMemberAccess.check(@lineNo, line, @collector)
    @staticMemberAccessWithoutDollar.check(@lineNo, line, @collector)
    @selfWithDollar.check(@lineNo, line, @collector)
  end

  def parseLine(line)
    print @lineNo,':', line
    checkIllegalMemberAccess(line)
    @lineNo = @lineNo + 1
  end

  def printReport
    @collector.printReports
  end

end

checker = PhpChecker.new
checker.collector = ProblemReportCollector.new

while line = STDIN.gets do
  line.chop
  checker.parseLine(line)
end

checker.printReport

