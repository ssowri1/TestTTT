//
//  HintsViewController.swift
//  Currency Value
//
//  Created by Sowrirajan S on 27/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import WebKit
class HintsViewController: UIViewController {
    @IBOutlet var hintsDataSource: HintsDataSource!
    var hintsArray = [String: String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        hintsArray = [
            "Prepare for your priorities" : "After your expenses and income, your goals are likely to have the biggest impact on how you allocate your savings. Be sure to remember long-term goals—it’s important that planning for retirement doesn’t take a back seat to shorter-term needs. Learn how to prioritize your savings goals so you have a clear idea of where to start saving.",
            
            "Note your expenses": "The first step to saving money is to figure out how much you spend. Keep track of all your expenses—that means every coffee, household item and cash tip. Once you have your data, organize the numbers by categories, such as gas, groceries and mortgage, and total each amount. Consider using your credit card or bank statements to help you with this.",
        
            "Draw the plan to save money": "Now that you’ve made a budget, create a savings category within it. Try to save 10 to 15 percent of your income. If your expenses are so high that you can’t save that much, it might be time to cut back. To do so, identify nonessentials that you can spend less on, such as entertainment and dining out, and find ways to save on your fixed monthly expenses.",
        
            "Automatic Deposting": "Almost all banks offer automated transfers between your checking and savings accounts. You can choose when, how much and where to transfer money or even split your direct deposit so a portion of every paycheck goes directly into your savings account. Splitting your direct deposit and setting up automated transfers.",
        
            "Moniter your savings level": "Review your budget and check your progress every month. Not only will this help you stick to your personal savings plan, but it also helps you identify and fix problems quickly. These simple ways to save may even inspire you to save more money every day and hit your goals faster.",
            
            "Choose the right way": "If you’re saving for short-term goals, consider using these FDIC-insured deposit accounts: Savings account Certificate of deposit (CD), which locks in your money for a fixed period of time at a rate that is typically higher than savings accounts. Securities, such as stocks or mutual funds. These investment products are available through investment accounts with a broker-dealer.",
            
            "Investment" : "If your income is low, you may be eligible to participate in an IDA program where your savings are matched. In return for attending financial education sessions and planning to save for a home, education, or business, you typically receive at least $1 for every $1 you save, and sometimes much more.",
            
            "Check your history of expense" : "Use your annual free credit report from the three credit reporting bureaus to look for inaccuracies or opportunities to raise your score. Credit scores are used by loan providers, landlords, and others to determine what they’ll sell you, and at what price. For example, a low credit score can increase the cost of a 60-month, $20,000 auto loan by more than $5,000.",
            
            "Get counciling": "The most widely available help managing your debt is with a Consumer Credit Counseling Services (CCCS) counselor. CCCS’ network of non-profit counselors can work with you confidentially and judgement-free to help you develop a budget, figure out your options, and negotiate with creditors to repay your debts.",
            
            "Refinance your stuffs": "Explore if you have the option to refinance your mortgage to a lower interest rate. On a 15-year $100,000 fixed-rate mortgage, lowering the rate from 7 percent to 6.5 percent can save you more than $5,000 in interest charges over the life of the loan. And, you will accumulate home equity more rapidly, thus increasing your ability to cover large emergency expenditures.",
            
            "Negotiation": "If you’re paying a lot of interest on your credit cards, it’s important to know that you do have some power as long as you’ve been making your payments. Not only do you have the right to negotiate your current interest rate with your credit card issuer, but you have the right to transfer your balance to an entirely different card as well.",
            
            "Save the nature" : "Keeping the lights on in your home may not be expensive on a per-watt basis, but it sure does cost money over time. To save as much as you can, turn off lights any time you leave your house – or even when you leave the room. Turning off lights when you have plenty of natural sunlight can also help keep your electric bill down over time."
        
        ]
        configureTableView()
    }
    
    func configureTableView() {
        hintsDataSource.hintsArray = hintsArray as NSDictionary
    }
    
}
