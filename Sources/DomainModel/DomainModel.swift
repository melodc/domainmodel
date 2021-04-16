struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount:Int, currency:String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ convertTo: String) -> Money {
        var usdAmount = 0
        if self.currency == "GBP" {
            usdAmount = self.amount * 2
        } else if self.currency == "EUR" {
            usdAmount = Int(Double(self.amount) / 1.5)
        } else if self.currency == "CAN" {
            usdAmount = Int(Double(self.amount) / 1.25)
        } else {
            usdAmount = self.amount
        }
        
        var convertedAmount = 0
        if convertTo == "GBP" {
            convertedAmount = usdAmount / 2
        } else if convertTo == "EUR" {
            convertedAmount = Int(Double(usdAmount) * 1.5)
        } else if convertTo == "CAN" {
            convertedAmount = Int(Double(usdAmount) * 1.25)
        } else {
            convertedAmount = usdAmount
        }

        return Money(amount: convertedAmount, currency: convertTo)
    }
    
    func add(_ secondMoney: Money) -> Money {
        let firstAmount = convert(secondMoney.currency).amount
        let total =  secondMoney.amount + firstAmount
        return Money(amount: total, currency: secondMoney.currency)
    }
    
    func subtract(_ secondMoney: Money) -> Money {
        let firstAmount = convert(secondMoney.currency).amount
        let total =  secondMoney.amount - firstAmount
        return Money(amount: total, currency: secondMoney.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Salary(let salary):
            return Int(salary)
        case .Hourly(let hourly):
            return Int(hourly * Double(hours))
        }
    }
    
    func raise(byAmount: Int) {
        switch self.type {
        case .Salary(let salary):
            self.type = .Salary(UInt(Int(salary) + byAmount))
        case .Hourly(let hourly):
            self.type = .Hourly(hourly + Double(byAmount))
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Salary(let salary):
            self.type = .Salary(UInt(Double(salary) + byAmount))
        case .Hourly(let hourly):
            self.type = .Hourly(Double(hourly + byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Salary(let salary):
            self.type = .Salary(UInt(Double(salary) * (1.0 + byPercent)))
        case .Hourly(let hourly):
            self.type = .Hourly(Double(hourly * (1.0 + byPercent)))
        }
    }
    
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet{
            if self.age < 16 {
                self.job = nil
          }
        }
    }
    var spouse: Person? {
        didSet{
            if self.age < 21 {
                self.spouse = nil
          }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job?.type)) spouse:\(String(describing: self.spouse?.firstName))]"
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
    
    func haveChild(_ child: Person) -> Bool {
        for member in self.members {
            if member.age > 21 {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    func householdIncome() -> Int {
        var total = 0
        for member in self.members {
            let income = member.job?.calculateIncome(2000) ?? 0
            total += income
        }
        return total
    }
}
