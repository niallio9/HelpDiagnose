#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov  8 11:08:40 2019

@author: niall
"""

from tkinter import *
from tkinter import messagebox
#
class AskQuestions():
    
    def set_states(self):
        return map((lambda var: var.get()), self.vars)
    
    def get_states(self): 
        self.states = list(self.set_states())
        print(self.states)
        self.master.destroy()
    
    def quit_sequence(self):
        self.quit = 1
#        print(self.quit)
        self.master.destroy()
    
    def __init__(self, heading='', picks=[], side=TOP, anchor=W):
        self.master = Tk()
        self.master.title(heading)
        self.master.geometry("600x500")
        self.quit = 0
        
        self.vars = []
        for pick in picks:
           var = IntVar()
           chk = Checkbutton(self.master, text=pick, font=('Helvetica', '14'), variable=var, background='White')
           chk.pack(side=side, anchor=anchor, expand=YES)
           self.vars.append(var)
           
        Button(self.master, text='Quit', font=('Helvetica', '20'), fg='Black', relief=RAISED, bd=20, command=self.quit_sequence).pack(side=LEFT, anchor=N)
        Button(self.master, text='Proceed', font=('Helvetica', '20'), fg = 'Green', relief=GROOVE, bd=5, command=self.get_states).pack(side=RIGHT, anchor=N)
        
        self.master.mainloop()

### Driver Code  
#obj=AskQuestions('tick me! tick me!', ['Pythonxxxxxxxxxxxxxxxxxx', 'Ruby', 'Perl', 'C++'])
#out = obj.get_states()
#print('getting the values for ' + str(out))

class AskNameAndAge():
    
    def set_states(self):
        return map((lambda var: var.get()), self.vars)
    
    def get_states(self):
        self.states = tuple(self.set_states())
        goahead = [1, 1]
        if not self.states[0] + self.states[1]: # if both first name and last name are empty
            messagebox.showerror('Error', 'Please enter something for First and/or Last name')
            goahead[0] = 0
            
        try:
            int(self.states[2]) # the age should be an integer
        except ValueError:
            print('you must enter an integer as an age')
            messagebox.showerror('Error', 'Please enter an integer as an age')
            goahead[1] = 0
            
        if all(goahead):
            print(self.states)
            self.master.destroy()
    
    def quit_sequence(self):
        self.quit = 1
#        print(self.quit)
        self.master.destroy()
        
    def __init__(self, heading='', side=TOP, anchor=N):
        self.master = Tk()
        self.master.title(heading)
#        master.geometry("600x500")
        self.quit = 0
        
        Label(self.master, text='First Name(s)').grid(row=0)
        Label(self.master, text='Last Name(s)').grid(row=1)
        Label(self.master, text='Age').grid(row=2)
        
        self.vars = []
        for i in range(0, 3):
           var = StringVar()
           e = Entry(self.master, font=('Helvetica', '14'), textvariable=var).grid(row=i, column=1)
           self.vars.append(var)
           
        Button(self.master, text='Quit', font=('Helvetica', '20'), fg='Black', relief=RAISED, bd=20, command=self.quit_sequence).grid(row=3, sticky=W, pady=5)
        Button(self.master, text='Proceed', font=('Helvetica', '20'), fg = 'Green', relief=GROOVE, bd=5, command=self.get_states).grid(row=3, column=2, sticky=E, pady=5)
        
        self.master.mainloop()

### Driver Code  
#obj = AskNameAndAge('please enter you details')
#out = obj.get_states()
#print('the deets are:' + str(out))


#from tkinter import *
#class Checkbar(Frame):
#    def __init__(self, parent=None, picks=[], side=TOP, anchor=W):
#       Frame.__init__(self, parent)
#       self.vars = []
#       for pick in picks:
#          var = IntVar()
#          chk = Checkbutton(self, text=pick, font=('Helvetica', '14'), variable=var, background='White')
#          chk.pack(side=side, anchor=anchor, expand=YES)
#          self.vars.append(var)
#      
#    def state(self):
#       return map((lambda var: var.get()), self.vars)
#  
#if __name__ == '__main__':
#   root = Tk(className='please tick my boxes')
#   lng = Checkbar(root, ['Pythonxxxxxxxxxxxxxxxxxx', 'Ruby', 'Perl', 'C++'])
#   lng.pack(side=TOP,  fill=X)
#   lng.config(relief=GROOVE, bd=5)
#   print(lng.keys())
#
#   def allstates(): 
#      print(list(lng.state()))
#      x = list(lng.state())
#      print(x)
#   Button(root, text='Quit', font=('Helvetica', '20'), fg='Black', command=root.quit).pack(side=LEFT, anchor=N)
#   Button(root, text='Peek', font=('Helvetica', '20'), fg = 'Green', command=allstates).pack(side=RIGHT, anchor=N)
#   root.mainloop()