<?php
/**
 * 
 */
class TestClass extends SubClass
{
    private static $staticmember;

    private $member1;

    private $member2;

    public static function function1($friends) {
    }

    public function function2($friend) {
        $this->function1($friends);
        $this->$member1->function2($friend);
        $this->member1.function1();
        $this->member2 = "testfile"."test";
        $this->member2 = "testfile".$result;

        self::$staticmember;
        $this->staticmember;
        self::staticmember;
        $self::staticmember;
        self::$staticmembers;
    }

}