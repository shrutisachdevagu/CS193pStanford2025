
func anyCommonElements<T:Sequence,U:Sequence>(_ lhs:T,_ rhs:U)->Bool where T.Element:Equatable,T.Element == U.Element {
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}

let someBool = anyCommonElements([1,2,3], [3,4])


func commonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> [T.Element] where T.Element: Equatable, T.Element == U.Element {
    var commonElementSequence: [T.Element] = []
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                if !commonElementSequence.contains(lhsItem) {
                    commonElementSequence.append(lhsItem)
                }
            }
        }
    }
    
    return commonElementSequence
}

commonElements([2,3,4,5], [34,4])
